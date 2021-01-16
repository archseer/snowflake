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
    # ../../profiles/graphical/games
    ../../profiles/graphical
    ../../profiles/misc/disable-mitigations.nix
    ../../profiles/misc/yubikey.nix
    # ../../profiles/postgres
    ../../users/speed
    ../../users/root
  ];

  # nvme0n1p1 = efi
  # nvme0n1p2 = vfat
  # nvme0n1p3 = ntfs
  # nvme0n1p4 = ext4

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

  hardware.enableRedistributableFirmware = true;

  # nix.maxJobs = lib.mkDefault 8;
  # nix.systemFeatures = [ "gccarch-haswell" ];

  security.mitigations.acceptRisk = true;

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  # Track list of enabled modules for localmodconfig generation.
  environment.systemPackages = [ pkgs.modprobed-db ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.03"; # Did you read the comment?
}
