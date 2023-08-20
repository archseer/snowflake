{
  pkgs,
  ...
}: {
  imports = [./pipewire.nix ./sway ../develop ../network ./im];

  nixpkgs.overlays = [
    #nixpkgs-wayland.overlay
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-wlr xdg-desktop-portal-gtk];
  };

  hardware.opengl.enable = true;
  # For Vulkan
  hardware.opengl.driSupport = true;

  boot = {
    tmp.useTmpfs = true;

    kernel.sysctl."kernel.sysrq" = 1;
  };

  home-manager.users.speed = {pkgs, ...}: {
    imports = [./misc/mpv];

    gtk = {
      enable = true;
      theme = {
        package = pkgs.pop-gtk-theme;
        name = "Pop";
      };
      iconTheme = {
        package = pkgs.paper-icon-theme;
        name = "Paper";
      };
      # TODO: gtk-cursor-theme-name..
    };

    # Wayland support in electron-based apps
    xdg.configFile."electron-flags.conf".text = ''
      --enable-features=UseOzonePlatform
      --ozone-platform=wayland
    '';
  };
 
  # Wayland support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

  environment.systemPackages = with pkgs; [
    evince
    imv
    # adapta-gtk-theme
    # cursor
    # dzen2
    # feh
    # ffmpeg-full
    # gnome3.adwaita-icon-theme
    # imagemagick
    # imlib2
    # librsvg
    # libsForQt5.qtstyleplugins
    # manpages
    pop-gtk-theme
    paper-icon-theme
    firefox-wayland
    chromium

    wf-recorder
    ffmpeg

    logseq
    anki
    # calibre

    # qt5.qtgraphicaleffects
    # stdmanpages
    # zathura
  ];

  fonts = {
    packages = with pkgs; [
      font-awesome # waybar icons: TODO: move to there
      noto-fonts
      noto-fonts-cjk
      twemoji-color-font
      inter
      fira-code
      fira-code-symbols
      fira-mono
      fira
      libertine
      roboto
      # proggyfonts
      proggy
    ];
    fontconfig.defaultFonts = {
      serif = ["Linux Libertine"];
      sansSerif = ["Inter"];
      monospace = ["Fira Code"];
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
