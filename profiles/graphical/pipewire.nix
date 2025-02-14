{
  pkgs,
  lib,
  ...
}: {
  # Enable sound.

  # Disable pulseaudio and ALSA
  services.pulseaudio.enable = lib.mkForce false;

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
