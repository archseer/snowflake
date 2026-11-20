# The core profile is automatically applied to all hosts.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = lib.mkDefault "Asia/Tokyo";

  environment = {
    systemPackages = with pkgs; [
      binutils
      curl
      dnsutils
      dosfstools
      fd
      sd
      git
      htop
      iputils
      jq
      # moreutils
      nmap
      ripgrep
      whois
      nvd
    ];

    shellAliases = {
      n = "nix";
    };
  };

  # Show what changed on every switch/test
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      if [[ -e /run/current-system ]]; then
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
      fi
    '';
  };

  # Avoid running out of space on /boot
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;

  nix = {
    gc.automatic = true;
    gc.options = lib.mkDefault "--delete-older-than 30d";
    optimise.automatic = true;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      allowed-users = ["@wheel"];
      # Keep the build inputs of anything still in use, like direnv shells
      keep-outputs = true;
      keep-derivations = true;
    };
    # daemonCPUSchedPolicy = "idle";
    channel.enable = false; # flakes only
  };

  # Use the system nixpkgs
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };

  security.protectKernelImage = lib.mkDefault true;

  systemd.oomd.enableUserSlices = true;
  systemd.slices."-".sliceConfig.ManagedOOMSwap = "kill";

  security.sudo.execWheelOnly = true;

  users.mutableUsers = false;
}
