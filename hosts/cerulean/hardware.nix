{ config, lib, modulesPath, hardware, ... }:
{
  require = [
    hardware.nixosModules.common-cpu-amd
    hardware.nixosModules.common-pc-ssd
  ];

  boot.kernelParams = [ "cryptomgr.notests" ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];

  boot.kernelModules = [ "kvm-amd"
    "nct6683" # fan speed, temperature and voltage sensors
  ];

  # boot.kernel.sysctl = [
  #   "net.ipv4.tcp_congestion_control" = "bbr";
  #   "net.core.default_qdisc" = "fq_codel"; # cake is also an option
  # ];

  # services.thermald.enable = lib.mkDefault true;
}
