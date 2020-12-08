{ pkgs, ... }:
let inherit (builtins) readFile;
in
{
  imports = [ ./sway ../develop ../network ./im ./misc/mpv.nix ];

  nixpkgs.overlays =  [
    #nixpkgs-wayland.overlay
  ];

  # Enable sound.

  # Disable ALSA
  sound.enable = false;
  # Disable pulseaudio
  hardware.pulseaudio.enable = false;

  # build programs with pulseaudio support, pipewire will handle them
  nixpkgs.config.pulseaudio = true;

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

  hardware.opengl.enable = true;

  boot = {
    # use the latest upstream kernel
    # kernelPackages = pkgs.linuxPackages_latest;

    tmpOnTmpfs = true;

    kernel.sysctl."kernel.sysrq" = 1;
  };

  home-manager.users.speed = { pkgs, ... }: {
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
  };

  environment = {

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
      pop-gtk-theme
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
      font-awesome # waybar icons: TODO: move to there
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      inter
      fira-code fira-code-symbols fira-mono fira
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
