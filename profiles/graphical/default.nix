{
  config,
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

  users.users.${config.my.user.name}.packages = with pkgs; [
    v4l-utils
  ];

  home-manager.sharedModules = [./home.nix];
 
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
    firefox
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
