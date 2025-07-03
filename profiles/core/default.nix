# The core profile is automatically applied to all hosts.
{
  lib,
  pkgs,
  inputs,
  ...
}: {
  nix.package = pkgs.nixVersions.stable;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = lib.mkDefault "Asia/Tokyo";

  environment = {
    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      direnv
      dnsutils
      dosfstools
      fd
      sd
      git
      htop
      powertop
      iputils
      jq
      # moreutils
      nmap
      ripgrep
      util-linux
      whois
    ];

    shellAliases = {
      n = "nix";
    };
  };

  nix = {
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      cores = 0;
      auto-optimise-store = true;
      sandbox = true;
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Need to configure home-manager to work with flakes
  home-manager.useGlobalPkgs = true; # is this equivalent to stateVersion 20.09?
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };

  security.protectKernelImage = true;

  services.earlyoom.enable = true;

  users.mutableUsers = false;
}
