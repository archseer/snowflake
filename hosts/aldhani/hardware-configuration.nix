{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
  ];
  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
  boot.initrd.kernelModules = ["nvme"];

  # 1 GB of RAM isn't enough to evaluate the flake during autoUpgrade
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 2048;
    }
  ];
}
