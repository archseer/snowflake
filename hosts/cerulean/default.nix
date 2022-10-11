{ hardware, lib, pkgs, ... }:
let
  inherit (builtins) readFile;

  kernel = pkgs.callPackage ./kernel.nix {};
  linuxPackages = (pkgs.linuxPackagesFor kernel);
in
{
  require = [
    ./hardware.nix
    ../../profiles/network # sets up wireless
    ../../profiles/graphical/games
    ../../profiles/graphical
    ../../profiles/misc/yubikey.nix
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
  boot.initrd.compressor = "${lib.getBin pkgs.zstd}/bin/zstd";

  boot.loader.efi.canTouchEfiVariables = true;

  # Setup root as encrypted LUKS volume

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3d953c33-2053-49c1-a4fc-064cdbd761c6";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/663d4e43-9596-49e5-b555-101fbfc6cf18";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6C9C-379F";
      fsType = "vfat";
    };

  # 8GB swapfile for hibernation

  swapDevices = [{device = "/swapfile"; size = 8192;}];

  # # Resume from encrypted volume's /swapfile
  # boot.resumeDevice = "/dev/mapper/cryptroot";
  # # filefrag -v /swapfile | awk '{ if($1=="0:"){print $4} }'
  # boot.kernelParams = [ "resume_offset=114857984" ];

  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ pkgs.wireless-regdb ];
  };

  # nix.maxJobs = lib.mkDefault 8;
  # nix.systemFeatures = [ "gccarch-haswell" ];

  boot.kernelParams = [ "mitigations=off" ];

  # powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # I'd like to keep it available but rfkill disable the signal, but not sure how.
  # networking.wireless.iwd.enable = lib.mkForce false;
  # TODO: find all the iptables/nftables modules needed in the kernel
  networking.firewall.enable = lib.mkForce false;

  # Track list of enabled modules for localmodconfig generation.
  environment.systemPackages = with pkgs; [ modprobed-db stress-ng lm_sensors piper zenmonitor pciutils acpica-tools linuxPackages.perf linuxPackages.turbostat ];
  services.ratbagd.enable = true; # ratbagd + piper = logitech mouse config

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
