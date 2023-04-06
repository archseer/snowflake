{
  pkgs,
  lib,
  ...
}: {
  # Enable sound.

  # build programs with pulseaudio support, pipewire will handle them
  # https://github.com/NixOS/nixpkgs/issues/139344
  nixpkgs.config.pulseaudio = true;
  # Disable pulseaudio and ALSA
  sound.enable = lib.mkForce false;
  hardware.pulseaudio.enable = lib.mkForce false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;

    wireplumber.enable = true;

    # Compatibility shims, adjust according to your needs
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
    # package = pkgs.pipewire-git;
  };

  environment.systemPackages = with pkgs; [
    # pulsemixer
    pavucontrol
  ];
}
