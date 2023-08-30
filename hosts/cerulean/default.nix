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
    ../../profiles/network # sets up wireless
    ../../profiles/network/tailscale.nix
    ../../profiles/graphical/games
    ../../profiles/graphical
    ../../profiles/misc/yubikey.nix
    ../../profiles/misc/ledger.nix
    # ../../profiles/misc/apparmor.nix
    # ../../profiles/postgres
    ../../users/speed
    ../../users/root
  ];

  # nvme0n1p1 = efi / vfat
  # nvme0n1p2 = ext4

  boot.loader.systemd-boot = {
    enable = true;
    # editor = false;
  };

  # use the latest upstream kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # use the custom kernel config
  boot.kernelPackages = linuxPackages;

  # boot.extraModulePackages = [ ];

  # use zstd compression instead of gzip for initramfs.
  boot.initrd.compressor = "zstd";

  boot.loader.efi.canTouchEfiVariables = true;

  # Setup root as encrypted LUKS volume

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3d953c33-2053-49c1-a4fc-064cdbd761c6";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/663d4e43-9596-49e5-b555-101fbfc6cf18";
    allowDiscards = true; # some security implications but not really too concerning to me
    bypassWorkqueues = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6C9C-379F";
    fsType = "vfat";
  };

  # Use zram for swap
  swapDevices = [];
  zramSwap.enable = true;
  # zram is relatively cheap, prefer swap
  boot.kernel.sysctl."vm.swappiness" = 180;
  boot.kernel.sysctl."vm.watermark_boost_factor" = 0;
  boot.kernel.sysctl."vm.watermark_scale_factor" = 125;
  # zram is in memory, no need to readahead
  boot.kernel.sysctl."vm.page-cluster" = 0;

  hardware = {
    enableRedistributableFirmware = true;
    firmware = [pkgs.wireless-regdb];
  };

  # nix.maxJobs = lib.mkDefault 8;
  # nix.systemFeatures = [ "gccarch-znver2" ];

  boot.kernelParams = ["mitigations=off"];

  # powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # I'd like to keep it available but rfkill disable the signal, but not sure how.
  # networking.wireless.iwd.enable = lib.mkForce false;

  # Track list of enabled modules for localmodconfig generation.
  environment.systemPackages = with pkgs; [
    modprobed-db
    piper
    zenmonitor
    lm_sensors # TODO: extract from laptop/default.nix
    linuxPackages.perf
    linuxPackages.turbostat
  ];
  services.ratbagd.enable = true; # ratbagd + piper = logitech mouse config

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
