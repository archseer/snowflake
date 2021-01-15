{ config, lib, modulesPath, hardware, ... }:
{
  require = [
    hardware.nixosModules.common-cpu-amd
    hardware.nixosModules.common-pc-ssd
  ];

  boot.kernelParams = [ "cryptomgr.notests" ];

  # Load surface_aggregator / surface_hid at stage 1 so we can use the keyboard
  # during LUKS.

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "uas" ];

  boot.kernelModules = [ "kvm-amd" ];

  # boot.kernel.sysctl = [
  #   "net.ipv4.tcp_congestion_control" = "bbr";
  #   "net.core.default_qdisc" = "fq_codel"; # cake is also an option
  # ];

  # services.thermald.enable = lib.mkDefault true;
}
