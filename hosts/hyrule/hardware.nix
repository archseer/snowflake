{ config, lib, modulesPath, hardware, ... }:
{
  require = [
    hardware.nixosModules.common-cpu-intel
    hardware.nixosModules.common-pc-laptop
    hardware.nixosModules.common-pc-ssd
  ];

  boot.kernelParams = [ "cryptomgr.notests" ];

  # Load surface_aggregator / surface_hid at stage 1 so we can use the keyboard
  # during LUKS.

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "uas"
    # required for keyboard support at init
    "intel_lpss" "intel_lpss_pci"
    "8250_dw"
    "surface_aggregator" "surface_aggregator_registry" "surface_hid"
  ];

  boot.kernelModules = [ "kvm-intel" ];

  services.thermald.enable = lib.mkDefault true;
}
