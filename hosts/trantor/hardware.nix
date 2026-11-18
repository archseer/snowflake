{
  lib,
  inputs,
  ...
}: {
  require = [
    inputs.hardware.nixosModules.framework-12th-gen-intel
  ];

  # AES-NI (with its own XTS) and dm-crypt are built into the kernel.
  boot.initrd.luks.cryptoModules = [];
  # Load surface_aggregator / surface_hid at stage 1 so we can use the keyboard
  # during LUKS.

  # upstream includes SATA drivers etc. which we don't build into the kernel.
  # boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "dm_mod" "dm_crypt" "cryptd"
  "atkbd" "i8042"];

  boot.kernelModules = ["kvm-intel"];

  hardware.cpu.intel.updateMicrocode = true;

  services.fwupd.enable = true;

  # hardware.framework.laptop13.audioEnhancement.enable = true;
}
