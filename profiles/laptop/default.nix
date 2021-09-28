{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    acpi
    lm_sensors
    wirelesstools
    pciutils
    usbutils
  ];

  # remap caps to escape/ctrl on built-in keyboard.
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.caps2esc ];
    udevmonConfig = ''
    - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
      DEVICE:
        EVENTS:
          EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  services.upower.enable = lib.mkDefault true;

  # --adaptive by default
  services.thermald.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # to enable brightness keys
  programs.light.enable = true;

  # sound.mediaKeys = lib.mkIf (!config.hardware.pulseaudio.enable) {
  #   enable = true;
  #   volumeStep = "1dB";
  # };

  # better timesync for unstable internet connections
  services.chrony.enable = true;
  services.timesyncd.enable = false;

  # power management features
  services.tlp.enable = true;
  # services.tlp.extraConfig = ''
  #   CPU_SCALING_GOVERNOR_ON_AC=performance
  #   CPU_SCALING_GOVERNOR_ON_BAT=powersave
  #   CPU_HWP_ON_AC=performance
  # '';
  services.logind.lidSwitch = "suspend";

  nixpkgs.overlays =
    let
      light_ov = self: super: {
        light = super.light.overrideAttrs (o: {
          src = self.fetchFromGitHub {
            owner = "haikarainen";
            repo = "light";
            rev = "ae7a6ebb45a712e5293c7961eed8cceaa4ebf0b6";
            sha256 = "00z9bxrkjpfmfhz9fbf6mjbfqvixx6857mvgmiv01fvvs0lr371n";
          };
        });
      };
    in
    [ light_ov ];
}
