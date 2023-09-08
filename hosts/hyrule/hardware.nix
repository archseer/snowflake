{
  lib,
  inputs,
  ...
}: {
  require = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  boot.kernelParams = ["cryptomgr.notests"];

  # Only load the crypto modules required instead of a blanket import.
  boot.initrd.luks.cryptoModules = ["aes"];

  # Load surface_aggregator / surface_hid at stage 1 so we can use the keyboard
  # during LUKS.

  # upstream includes SATA drivers etc. which we don't build into the kernel.
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce [
    "xhci_pci"
    "nvme"
    "sd_mod"
    "dm_mod"
    "dm_crypt"
    "cryptd"
    # required for keyboard support at init
    "intel_lpss"
    "intel_lpss_pci"
    "8250_dw"
    "surface_aggregator"
    "surface_aggregator_registry"
    "surface_hid_core"
    "surface_hid"
  ];

  boot.kernelModules = ["kvm-intel"];

  hardware.cpu.intel.updateMicrocode = true;
}
