{
  config,
  lib,
  modulesPath,
  inputs,
  ...
}: {
  require = [
    inputs.hardware.nixosModules.framework-12th-gen-intel
  ];

  boot.kernelParams = ["cryptomgr.notests"];

  # Only load the crypto modules required instead of a blanket import.
  boot.initrd.luks.cryptoModules = ["aes"];

  # Load surface_aggregator / surface_hid at stage 1 so we can use the keyboard
  # during LUKS.

  # upstream includes SATA drivers etc. which we don't build into the kernel.
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "dm_mod" "dm_crypt" "cryptd"];

  boot.kernelModules = ["kvm-intel"];

  services.thermald.enable = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = true;

  services.fwupd.enable = true;
}
