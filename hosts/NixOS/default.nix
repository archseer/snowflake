{
  ### root password is empty by default ###
  imports = [../../users/nixos ../../users/root];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.iwd.enable = true;

  fileSystems."/" = {device = "/dev/disk/by-label/nixos";};
}
