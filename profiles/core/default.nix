# The core profile is automatically applied to all hosts.
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) fileContents;
in {
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
      git
      htop
      powertop
      iputils
      jq
      manix
      nix-index
      # moreutils
      nmap
      sd
      ripgrep
      util-linux
      whois
    ];

    shellAliases = {
      # nix
      n = "nix";
      np = "n profile";
      ni = "np install";
      nr = "np remove";
      ns = "n search --no-update-lock-file";
      nf = "n flake";
      srch = "ns nixpkgs";
      nrb = "sudo nixos-rebuild";
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

  programs.bash = {
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    shellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };

  security = {
    # hideProcessInformation = false; # this doesn't work with systemd + cgroupsv2
    protectKernelImage = true;
  };

  services.earlyoom.enable = true;

  users.mutableUsers = false;
}
