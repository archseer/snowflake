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
  # Everything the initrd needs is built into the kernel.
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce [];

  boot.kernelModules = ["kvm-intel"];

  hardware.cpu.intel.updateMicrocode = true;

  services.fwupd.enable = true;

  # hardware.framework.laptop13.audioEnhancement.enable = true;
}
