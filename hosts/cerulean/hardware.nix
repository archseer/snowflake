{
  lib,
  inputs,
  ...
}: {
  require = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  # AES-NI (with its own XTS) and dm-crypt are built into the kernel.
  boot.initrd.luks.cryptoModules = [];

  # Everything the initrd needs is built into the kernel.
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce [];

  boot.kernelModules = [
    "kvm-amd"
    # "zenpower" # use this instead of k10temp
  ];
  # boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
  # boot.blacklistedKernelModules = [ "k10temp" ];

  # boot.kernel.sysctl = [
  #   "net.ipv4.tcp_congestion_control" = "bbr";
  #   "net.core.default_qdisc" = "fq_codel"; # cake is also an option
  # ];

  hardware.cpu.amd.updateMicrocode = true;

  services.fwupd.enable = true;
}
