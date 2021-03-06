{ pkgs, lib, ... }:
let inherit (builtins) readFile;
in
{
  imports = [ ./sway ../develop ../network ./im ];

  nixpkgs.overlays =  [
    #nixpkgs-wayland.overlay
  ];

  # Enable sound.

  # would require snd_pci_oss to be built into the kernel
  sound.enableOSSEmulation = false;

  # TEMP: back to pulseaudio
  # hardware.pulseaudio.enable = true;
  # nixpkgs.config.pulseaudio = true;

  # # Disable ALSA
  # sound.enable = false;
  # # Disable pulseaudio
  # hardware.pulseaudio.enable = pkgs.lib.mkForce false;

  # # build programs with pulseaudio support, pipewire will handle them
  # nixpkgs.config.pulseaudio = true;

  # # pipewire
  # # Not strictly required but pipewire will use rtkit if it is present
  # # security.pam.loginLimits = [
  # #   { domain = "@users"; item = "memlock"; type = "soft"; value = "1048576"; }
  # #   { domain = "@users"; item = "memlock"; type = "hard"; value = "unlimited"; }
  # #   # Allow using RT (RR/FIFO) scheduling
  # #   { domain = "@users"; item = "rtprio";  type = "soft"; value = "46"; }
  # #   { domain = "@users"; item = "rtprio";  type = "hard"; value = "49"; }
  # #   # Get higher user process priority over background system services and allow
  # #   # higher normal scheduling priorities
  # #   { domain = "@users"; item = "priority"; type = "soft"; value = "-2"; }
  # #   { domain = "@users"; item = "nice"; type = "soft"; value = "-19"; }
  # #   { domain = "@users"; item = "nice"; type = "hard"; value = "-20"; }
  # #   { domain = "@messagebus"; item = "priority"; type = "soft"; value = "-10"; }
  # # ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    media-session.enable = true;
    # Compatibility shims, adjust according to your needs
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
    # socketActivation ?
    # package = pkgs.pipewire-git;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  programs.sway.extraSessionCommands = lib.mkBefore ''
    # Screensharing
    export XDG_CURRENT_DESKTOP=sway
  '';

  hardware.opengl.enable = true;

  boot = {
    # use the latest upstream kernel
    # kernelPackages = pkgs.linuxPackages_latest;

    tmpOnTmpfs = true;

    kernel.sysctl."kernel.sysrq" = 1;
  };

  home-manager.users.speed = { pkgs, ... }: {
    imports = [ ./misc/mpv ];

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
      chromium
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
      twemoji-color-font
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
