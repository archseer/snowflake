{ config, lib, modulesPath, hardware, ... }:
{
  require = [
    hardware.nixosModules.common-cpu-intel
    hardware.nixosModules.common-pc-laptop
    hardware.nixosModules.common-pc-ssd
  ];

  boot.kernelParams = [ "cryptomgr.notests" ];

  # Only load the crypto modules required instead of a blanket import.
  boot.initrd.luks.cryptoModules = [ "aes" ];

  # Load surface_aggregator / surface_hid at stage 1 so we can use the keyboard
  # during LUKS.

  # upstream includes SATA drivers etc. which we don't build into the kernel.
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme"
    # required for keyboard support at init
    "intel_lpss" "intel_lpss_pci"
    "8250_dw"
    "surface_aggregator" "surface_aggregator_registry" "surface_hid_core" "surface_hid"
  ];

  boot.kernelModules = [ "kvm-intel" ];

  services.thermald.enable = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = true;
}
