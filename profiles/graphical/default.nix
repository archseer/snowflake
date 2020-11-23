{ pkgs, ... }:
let inherit (builtins) readFile;
in
{
  imports = [ ./sway ../develop ../network ./im ];

  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;

  boot = {
    # use the latest upstream kernel
    kernelPackages = pkgs.linuxPackages_latest;

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
      # papirus-icon-theme
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
      fira-code fira-code-symbols fira-mono fira-sans
      libertine
      roboto
      proggyfonts
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
