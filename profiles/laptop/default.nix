{
  pkgs,
  lib,
  ...
}: {
  # Don't block boot/nixos-rebuild on all interfaces, wired usually unplugged
  systemd.network.wait-online.enable = false;

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl # to enable brightness keys
    powertop
    lm_sensors
  ];

  # remap caps to escape/ctrl on built-in keyboard.
  environment.etc."dual-function-keys.yaml".text = ''
    TIMING:
      TAP_MILLISEC: 200
      DOUBLE_TAP_MILLISEC: 0

    MAPPINGS:
      - KEY: KEY_LEFTSHIFT
        TAP: [KEY_LEFTSHIFT, KEY_9]
        HOLD: KEY_LEFTSHIFT
      - KEY: KEY_RIGHTSHIFT
        TAP: [KEY_RIGHTSHIFT, KEY_0]
        HOLD: KEY_RIGHTSHIFT
      - KEY: KEY_CAPSLOCK
        TAP: KEY_ESC
        HOLD: KEY_LEFTCTRL
  '';
  services.interception-tools = {
    enable = true;
    plugins = [pkgs.interception-tools-plugins.dual-function-keys];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          # Target only the built-in keyboard
          NAME: AT Translated Set 2 keyboard
          EVENTS:
            EV_KEY: [KEY_LEFTSHIFT, KEY_RIGHTSHIFT, KEY_CAPSLOCK]
    '';
  };

  services.upower.enable = lib.mkDefault true;

  # --adaptive by default
  services.thermald.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # better timesync for unstable internet connections
  services.chrony = {
    enable = true;
    enableNTS = true;
    servers = ["time.cloudflare.com" "nts.netnod.se" "ptbtime1.ptb.de"];
  };
  services.timesyncd.enable = false;

  # power management features
  services.tlp.enable = true;
  services.tlp.settings = {
    USB_ALLOWLIST="32ac:0002"; # Suspend Framework HDMI card
  };
}
