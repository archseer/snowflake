{
  lib,
  inputs,
  ...
}: {
  require = [
    inputs.hardware.nixosModules.framework-12th-gen-intel
  ];

  boot.kernelParams = ["cryptomgr.notests"];

  # Only load the crypto modules required instead of a blanket import.
  boot.initrd.luks.cryptoModules =  [ "aes" "aes_generic"
          "cbc" "xts" "lrw" "sha1" "sha256" "sha512"
          "algif_skcipher"
  ];
  # Load surface_aggregator / surface_hid at stage 1 so we can use the keyboard
  # during LUKS.

  # upstream includes SATA drivers etc. which we don't build into the kernel.
  # boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "dm_mod" "dm_crypt" "cryptd"
  "atkbd" "i8042"];

  boot.kernelModules = ["kvm-intel"];

  hardware.cpu.intel.updateMicrocode = true;

  services.fwupd.enable = true;
}
