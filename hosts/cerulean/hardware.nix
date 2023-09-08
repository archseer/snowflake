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

  boot.kernelParams = ["cryptomgr.notests"];

  # Only load the crypto modules required instead of a blanket import.
  boot.initrd.luks.cryptoModules = ["aes"];

  # upstream includes SATA drivers etc. which we don't build into the kernel.
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];

  boot.kernelModules = [
    "kvm-amd"
    "nct6683" # fan speed, temperature and voltage sensors
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
