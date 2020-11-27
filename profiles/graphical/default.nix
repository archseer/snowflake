{ pkgs, ... }:
let inherit (builtins) readFile;
in
{
  imports = [ ./sway ../develop ../network ./im ];

  nixpkgs.overlays =  [
    #nixpkgs-wayland.overlay
  ];

  # Enable sound.

  sound.enable = true;

  # hardware.pulseaudio.enable = true;
  # nixpkgs.config.pulseaudio = true;

  # pipewire
  # Not strictly required but pipewire will use rtkit if it is present
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    # Compatibility shims, adjust according to your needs
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
    # socketActivation ?
  };
  hardware.pulseaudio.enable = false;

  boot = {
    # use the latest upstream kernel
    # kernelPackages = pkgs.linuxPackages_latest;

    tmpOnTmpfs = true;

    kernel.sysctl."kernel.sysrq" = 1;
  };

  environment = {

    # etc = {
    #   "xdg/gtk-3.0/settings.ini" = {
    #     text = ''
    #       [Settings]
    #       gtk-icon-theme-name=Papirus
    #       gtk-theme-name=Adapta
    #       gtk-cursor-theme-name=Adwaita
    #     '';
    #     mode = "444";
    #   };
    # };

    # sessionVariables = {
    #   # Theme settings
    #   QT_QPA_PLATFORMTHEME = "gtk2";

    #   GTK2_RC_FILES =
    #     let
    #       gtk = ''
    #         gtk-icon-theme-name="Papirus"
    #         gtk-cursor-theme-name="Adwaita"
    #       '';
    #     in
    #     [
    #       ("${pkgs.writeText "iconrc" "${gtk}"}")
    #       "${pkgs.adapta-gtk-theme}/share/themes/Adapta/gtk-2.0/gtkrc"
    #       "${pkgs.gnome3.gnome-themes-extra}/share/themes/Adwaita/gtk-2.0/gtkrc"
    #     ];
    # };

    systemPackages = with pkgs; [
      evince
      imv
      # adapta-gtk-theme
      # cursor
      # dzen2
      # feh
      # ffmpeg-full
      # gnome3.adwaita-icon-theme
      # gnome3.networkmanagerapplet
      # gnome-themes-extra
      # imagemagick
      # imlib2
      # librsvg
      # libsForQt5.qtstyleplugins
      # manpages
      paper-icon-theme
      # pulsemixer
      pavucontrol
      firefox-wayland
      # qt5.qtgraphicaleffects
      # stdmanpages
      # zathura

      # TODO: mpv
    ];
  };

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      inter
      fira-code fira-code-symbols fira-mono fira
      libertine
      roboto
      proggyfonts
      font-awesome # waybar icons: TODO: move to there
    ];
    fontconfig.defaultFonts = {
      serif = ["Linux Libertine"];
      sansSerif = ["Inter"];
      monospace = [ "Fira Code" ];
    };
    # Bind Inter to Helvetica
    fontconfig.localConf = ''
      <fontconfig>
        <match>
          <test name="family"><string>Helvetica</string></test>
          <edit name="family" mode="assign" binding="strong">
            <string>Inter</string>
          </edit>
        </match>
      </fontconfig>
    '';
  };

}
