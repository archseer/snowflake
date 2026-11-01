{
  config,
  lib,
  pkgs,
  ...
}: {
  # hardware-configuration

  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ../../profiles/network/headscale.nix
    ../../profiles/network/tailscale.nix
    ../../profiles/ssh
    ../../users/speed
  ];

  # locked, use speed + sudo
  users.users.root.hashedPassword = "!";

  services.tailscale.extraSetFlags = lib.mkForce ["--advertise-exit-node" "--ssh=false"];

  # Put the public addresses in the DERP map so clients don't have to
  # resolve headscale.mxxn.io to reach the relay
  services.headscale.settings.derp.server = {
    ipv4 = "209.97.164.130";
    ipv6 = "2400:6180:0:d1::6ec:3001";
  };

  # required for tailscale exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.domain = "";
  services.openssh.enable = true;
  services.openssh.openFirewall = false;

  # rsync for scripts/deploy-site.
  environment.systemPackages = [pkgs.helix pkgs.rsync];

  # Auto upgrade once per day if flake has changed
  system.autoUpgrade = {
    enable = true;
    flake = "github:archseer/snowflake";
    allowReboot = true;
    rebootWindow = {
      lower = "04:00";
      upper = "06:00";
    };
  };

  # Auto GC older generations
  nix.gc.options = "--delete-older-than 7d";
  # collect garbage during builds below 1 GiB free
  nix.settings = {
    min-free = 1024 * 1024 * 1024;
    max-free = 4 * 1024 * 1024 * 1024;
  };

  system.stateVersion = "24.05";

  networking.firewall.allowedTCPPorts = [80 443];

  systemd.tmpfiles.rules = [
    "d /var/www/mxxn 0755 speed users -"
    "d /var/www/polyfox 0755 speed users -"
    "d /var/www/sites 0755 speed users -"
    "d /var/www/private 0755 speed users -"
  ];

  # Tailnet-only sites (/var/www/private) resolve to aldhani's tailnet
  # address inside the tailnet, so caddy sees a tailnet client IP.
  services.headscale.settings.dns.extra_records = lib.concatMap (name: [
    { name = "${name}.mxxn.io"; type = "A"; value = "100.64.0.1"; }
    { name = "${name}.mxxn.io"; type = "AAAA"; value = "fd7a:115c:a1e0::1"; }
  ]) ["yama"];

  # mxxn.io
  services.caddy = {
    enable = true;

    # Only issue on-demand certificates for hosts that have a site
    globalConfig = ''
      on_demand_tls {
        ask http://127.0.0.1:5555/
      }
    '';
    virtualHosts."http://127.0.0.1:5555" = {
      logFormat = null;
      extraConfig = ''
        bind 127.0.0.1
        @site file {
          root /var/www/sites
          try_files {query.domain}/index.html
        }
        @private file {
          root /var/www/private
          try_files {query.domain}/index.html
        }
        respond @site 200
        respond @private 200
        respond 404
      '';
    };

    # Not a *.mxxn.io site: caddy then skips certificates for every
    # subdomain it covers, headscale.mxxn.io included.
    virtualHosts."https://" = {
      logFormat = ''
        output file ${config.services.caddy.logDir}/access-sites.log
      '';
      extraConfig = ''
        tls {
          on_demand
        }
        @private {
          host *.mxxn.io
          file {
            root /var/www/private
            try_files {host}/index.html
          }
        }
        handle @private {
          @public not remote_ip 100.64.0.0/10 fd7a:115c:a1e0::/48
          respond @public 404
          encode zstd gzip
          root * /var/www/private/{host}
          file_server {
            hide .*
          }
        }
        @site host *.mxxn.io
        handle @site {
          encode zstd gzip
          root * /var/www/sites/{host}
          file_server {
            hide .*
          }
        }
        respond 404
      '';
    };

    virtualHosts."mxxn.io".extraConfig = ''
    encode zstd gzip
    file_server {
      hide .*
    }
    root * /var/www/mxxn
    '';

    virtualHosts."polyfox.io".extraConfig = ''
    encode zstd gzip
    file_server {
      hide .*
    }
    root * /var/www/polyfox
    '';
  };
}
