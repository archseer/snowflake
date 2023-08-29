{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # hardware-configuration

  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ../../profiles/ssh
    ../../users/speed
    ../../users/root
  ];

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  # networking.hostName = "midna"; already set by flake
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhYkvu/rVDYYlcM8Rq8HP3KPY2AX3mCvmyZ+/L1/yuh speed@hyrule.local''
  ];

  environment.systemPackages = [pkgs.helix];

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
