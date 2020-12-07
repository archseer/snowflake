{ hardware, lib, pkgs, ... }:
let
  inherit (builtins) readFile;

  kernel = pkgs.callPackage ./kernel.nix {};
  linuxPackages = pkgs.linuxPackagesFor kernel;
in
{
  require = [
    ./hardware.nix
    ../../profiles/laptop
    ../../profiles/network # sets up wireless
    # ../../profiles/graphical/games
    ../../profiles/graphical
    ../../profiles/misc/disable-mitigations.nix
    # ../../profiles/postgres
    # ../../profiles/ssh
    ../../users/speed
    ../../users/root
  ];

  # nvme0n1p1 = efi
  # nvme0n1p2 = vfat
  # nvme0n1p3 = msoft ntfs
  # nvme0n1p4 = ext4

  boot.loader.systemd-boot = {
    enable = true;
    # editor = false;
  };

  # use the latest upstream kernel
  # boot.kernelPackages = pkgs.linuxPackages_5_9;
  # boot.kernelPackages = pkgs.linuxPackages_surface;
  boot.kernelPackages = linuxPackages;
  boot.extraModulePackages = [
    # pkgs.linuxPackages_surface.surface-aggregator
    linuxPackages.surface-aggregator
  ];

  boot.loader.efi.canTouchEfiVariables = true;

  # Setup root as encrypted LUKS volume

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f0173313-719c-4e09-a766-e74d96d35ee8";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/253b225b-eb1a-4f16-8e17-18b9c33e7ce8";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/92D3-1812";
      fsType = "vfat";
    };

  # 8GB swapfile for hibernation

  swapDevices = [{device = "/swapfile"; size = 8192;}];

  hardware.enableRedistributableFirmware = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # nix.maxJobs = lib.mkDefault 8;
  # nix.systemFeatures = [ "gccarch-haswell" ];

  security.mitigations.acceptRisk = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  # Track list of enabled modules for localmodconfig generation.
  services.modprobed-db.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.03"; # Did you read the comment?
}
