{ hardware, lib, pkgs, ... }:
let
  inherit (builtins) readFile;
in
{
  require = [
    # hardware.nixosModules.common-cpu-intel
    # hardware.nixosModules.common-pc-laptop
    # hardware.nixosModules.common-pc-ssd
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

  # Load surface_aggregator / surface_hid at stage 1 so we can use the keyboard
  # during LUKS.

  # use the latest upstream kernel
  # boot.kernelPackages = pkgs.linuxPackages_5_9;
  boot.kernelPackages = pkgs.linuxPackages_surface;
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "uas" ];
  # boot.initrd.kernelModules = [
    # "intel_lpss" "intel_lpss_pci"
    # "8250_dw"
    # "surface_aggregator" "surface_aggregator_registry" "surface_hid"
  # ];
  boot.blacklistedKernelModules = [
    "surface_aggregator"
    "surface_aggregator_registry"
    "surface_aggregator_cdev"
    "surface_acpi_notify"
    "surface_battery"
    "surface_dtx"
    "surface_hid"
    "surface_hotplug"
    "surface_perfmode"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  # boot.extraModulePackages = [ pkgs.linuxPackages_5_9.surface-aggregator ];
  boot.extraModulePackages = [
    pkgs.linuxPackages_surface.surface-aggregator
  ];
  boot.kernelPatches = [{
    name = "surface";
    patch = null;
    extraConfig = ''
      SERIAL_DEV_BUS y
      SERIAL_DEV_CTRL_TTYPORT y
      PINCTRL_ICELAKE y
      INTEL_IDMA64 m
      MFD_INTEL_LPSS m
      MFD_INTEL_LPSS_ACPI m
      MFD_INTEL_LPSS_PCI m
      SERIAL_8250_DW m
      SERIAL_8250_DMA y
      SERIAL_8250_LPSS y
      X86_INTEL_LPSS y
      SERIAL_8250_DETECT_IRQ n
      SERIAL_8250_DEPRECATED_OPTIONS n
      '';
    }];

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
  # networking.interfaces.wlp0s20f3.useDHCP = true;
  # networking.interfaces.wlan0.useDHCP = true;

  # nix.maxJobs = lib.mkDefault 8;
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
  system.stateVersion = "21.03"; # Did you read the comment?
}
