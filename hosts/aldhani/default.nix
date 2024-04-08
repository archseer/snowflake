{
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

  # required for tailscale exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;i
    "net.ipv6.conf.all.forwarding" = 1;
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhYkvu/rVDYYlcM8Rq8HP3KPY2AX3mCvmyZ+/L1/yuh speed@hyrule.local''
  ];

  environment.systemPackages = [pkgs.helix];

  # Auto upgrade once per day if flake has changed
  system.autoUpgrade = {
    enable = true;
    flake = "github:archseer/snowflake";
  };

  # Auto GC older generations
  nix.gc.options = "--delete-older-than 7d";

  networking.firewall.allowedTCPPorts = [80 443];

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
