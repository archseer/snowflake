{
  config,
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
    ../../users/root
  ];

  services.tailscale.extraSetFlags = ["--advertise-exit-node"];

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
  users.users.root.openssh.authorizedKeys.keys = config.my.user.sshKeys;

  environment.systemPackages = [pkgs.helix];

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

  # The file_server roots below; caddy can't create them itself.
  systemd.tmpfiles.rules = [
    "d /var/www/mxxn 0755 root root -"
    "d /var/www/polyfox 0755 root root -"
  ];

  # mxxn.io
  services.caddy = {
    enable = true;

    virtualHosts."mxxn.io".extraConfig = ''
    encode zstd gzip
    file_server
    root * /var/www/mxxn
    '';

    virtualHosts."polyfox.io".extraConfig = ''
    encode zstd gzip
    file_server
    root * /var/www/polyfox
    '';
  };
}
