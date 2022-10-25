{
  modulesPath,
  lib,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix"
  ];

  # Work around zfs issues https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce ["btrfs" "vfat" "f2fs" "xfs" "ntfs"];

  networking.wireless.enable = false;
  networking.wireless.iwd.enable = true;
}
