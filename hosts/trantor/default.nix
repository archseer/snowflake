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

  boot.initrd.supportedFilesystems = [ "btrfs" ];

  environment.systemPackages = [pkgs.btrfs-progs pkgs.compsize];

  
  # Take an empty *readonly* snapshot of the root subvolume,
  # which we'll eventually rollback to on every boot.
  # sudo mount /dev/mapper/cryptroot -o subvol=root /mnt/root
  # btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

  # sudo nix run github:nix-community/disko --extra-experimental-features flakes --extra=experimental-features nix-command -- --mode disko --flake github:archseer/snowflake#trantor
  # --arg disks ["/dev/nvme0p1"] not necessary?
  disko.devices = {
    disk = {
       nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "EFI";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            # Setup as encrypted LUKS volume
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                extraOpenArgs = [
                    "--allow-discards"
                    "--perf-no_read_workqueue"
                    "--perf-no_write_workqueue"
                ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-L" "nixos" ]; # -f ?
                  subvolumes = { # TODO: consider autodefrag and commit=120
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd:1" "noatime" ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd:1" "noatime" ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd:1" "noatime" ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "compress=zstd:1" "noatime" ];
                    };
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "compress=zstd:1" "noatime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  # Use zram for swap
  swapDevices = [ ];
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
  # nix.systemFeatures = [ "gccarch-haswell" ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  security.pam.services.login.fprintAuth = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
