{
  lib,
  pkgs,
  ...
}: let
  kernel = pkgs.callPackage ./kernel.nix {};
  linuxPackages = pkgs.linuxPackagesFor kernel;
in {
  require = [
    ./hardware.nix
    ../../profiles/zram # Use zram for swap
    ../../profiles/laptop
    ../../profiles/network # sets up wireless
    ../../profiles/network/tailscale.nix
    ../../profiles/graphical/games
    ../../profiles/graphical
    ../../profiles/misc/yubikey.nix
    ../../users/speed
    ../../users/root
  ];

  boot.initrd.systemd.enable = true;
  # boot.initrd.systemd.emergencyAccess = true;
  # boot.plymouth.enable = true;

  boot.loader.systemd-boot.enable = true;
  # boot.loader.systemd-boot.editor = false;

  # use the custom kernel config
  boot.kernelPackages = linuxPackages;

  # use zstd compression instead of gzip for initramfs.
  boot.initrd.compressor = "zstd";

  boot.loader.efi.canTouchEfiVariables = true;

  # btrfs
  boot.initrd.supportedFilesystems = ["btrfs"];
  services.btrfs.autoScrub.enable = true;
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
                # https://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html
                settings = {crypttabExtraOpts = ["fido2-device=auto" "token-timeout=10"];};
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "nixos"]; # -f ?
                  subvolumes = {
                    # TODO: consider autodefrag and commit=120
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = ["compress=zstd:1" "noatime"];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = ["compress=zstd:1" "noatime"];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["compress=zstd:1" "noatime"];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = ["compress=zstd:1" "noatime"];
                    };
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["compress=zstd:1" "noatime"];
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

  swapDevices = []; # Use zram for swap

  hardware = {
    enableRedistributableFirmware = true;
    firmware = [pkgs.wireless-regdb];
  };

  # nix.maxJobs = lib.mkDefault 8;
  # nix.systemFeatures = [ "gccarch-alderlake" ];

  boot.kernelParams = ["mitigations=off"];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  security.pam.services.login.fprintAuth = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
