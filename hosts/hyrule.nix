{ hardware, nixos, pkgs, ... }:
let
  inherit (nixos) lib;
  inherit (builtins) readFile;
in
{
  imports = [
    "${hardware}/common/cpu/intel"
    "${hardware}/common/pc/laptop"
    "${hardware}/common/pc/ssd"
    # ../profiles/graphical/games
    # ../profiles/graphical
    # ../profiles/misc
    # ../profiles/misc/disable-mitigations.nix
    # ../profiles/postgres
    # ../profiles/ssh
    ../users/speed
  ];

  # nvme0n1p1 = efi
  # nvme0n1p2 = vfat
  # nvme0n1p3 = msoft ntfs
  # nvme0n1p4 = ext4

  boot.loader.systemd-boot = {
    enable = true;
    # editor = false;
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" 
    "surface_aggregator" "surface_aggregator_registry" "surface_hid"
    "intel_lpss" "intel_lpss_pci"
    "8250_dw"
  ];
  boot.extraModulePackages = [ pkgs.linuxPackages.surface-aggregator ];

  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.cryptroot = "/dev/nvme0n1p4";

  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B361-1241";
    fsType = "vfat";
  };

  swapDevices = [{device = "/swapfile"; size = 8388604;}];

  hardware.enableRedistributableFirmware = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  networking.wireless.iwd.enable = true;
  services.connman.enable = true;
  services.connman.wifi.backend = "iwd";

  nix.maxJobs = lib.mkDefault 8;
  # nix.systemFeatures = [ "gccarch-haswell" ];

  security.mitigations.acceptRisk = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
