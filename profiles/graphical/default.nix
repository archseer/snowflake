{
  pkgs,
  ...
}: {
  imports = [./pipewire.nix ./sway ../develop ../network ./im];

  nixpkgs.overlays = [
    #nixpkgs-wayland.overlay
  ];

  hardware.graphics.enable = true;

  boot = {
    tmp.useTmpfs = true;

    kernel.sysctl."kernel.sysrq" = 1;
  };

  users.users.speed.packages = with pkgs; [
    v4l-utils
  ];

  home-manager.users.speed = {pkgs, ...}: {
    imports = [./misc/mpv];

    gtk = {
      enable = true;
      # theme = {
      #   package = pkgs.pop-gtk-theme;
      #   name = "Pop";
      # };
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

  environment.systemPackages = with pkgs; [
    evince
    imv
    # cursor
    # dzen2
    # feh
    # ffmpeg-full
    # imagemagick
    # imlib2
    # librsvg
    # libsForQt5.qtstyleplugins
    # manpages
    paper-icon-theme
    firefox-wayland
    chromium

    wf-recorder
    ffmpeg

    # logseq
    # obsidian

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
      noto-fonts-cjk-sans
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
      cozette
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
