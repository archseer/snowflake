{
  hardware,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) readFile;

  kernel = pkgs.callPackage ./kernel.nix {};
  linuxPackages = pkgs.linuxPackagesFor kernel;
in {
  require = [
    ./hardware.nix
    ../../profiles/laptop
    ../../profiles/network # sets up wireless
    ../../profiles/graphical/games
    ../../profiles/graphical
    ../../profiles/misc/yubikey.nix
    # ../../profiles/postgres
    ../../users/speed
    ../../users/root
  ];

  networking.firewall.enable = lib.mkForce false;

  # nvme0n1p1 = efi
  # nvme0n1p2 = vfat
  # nvme0n1p3 = ntfs
  # nvme0n1p4 = ext4

  boot.loader.systemd-boot = {
    enable = true;
    # editor = false;
  };

  # use the latest upstream kernel
  # boot.kernelPackages = pkgs.linuxPackages_5_14;
  # use the custom kernel config
  boot.kernelPackages = linuxPackages;

  # boot.extraModulePackages = [ ];

  # use zstd compression instead of gzip for initramfs.
  boot.initrd.compressor = "${lib.getBin pkgs.zstd}/bin/zstd";

  boot.loader.efi.canTouchEfiVariables = true;

  # Setup root as encrypted LUKS volume

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6545af13-5ef5-4239-af46-8387923adb83";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/8e71082e-b583-4848-a4c0-8f05709d0151";
    allowDiscards = true; # some security implications but not really too concerning to me
    bypassWorkqueues = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/EFC9-3E40";
    fsType = "vfat";
  };

  # Use zram for swap
  swapDevices = [ ];
  zramSwap.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    firmware = [pkgs.wireless-regdb];
  };

  # nix.maxJobs = lib.mkDefault 8;
  # nix.systemFeatures = [ "gccarch-haswell" ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # Track list of enabled modules for localmodconfig generation.
  environment.systemPackages = [pkgs.modprobed-db];

  security.pam.services.login.fprintAuth = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
