{pkgs, ...}: {
  imports = [./zsh ./podman];
  home-manager.sharedModules = [./home.nix ./wezterm/home.nix];

  # udev rules to flash qmk keyboards
  hardware.keyboard.qmk.enable = true;

  environment = {
    sessionVariables = {
      PAGER = "less";
      LESS = "-iFJMRWX -z-4 -x4";
      HELIX_RUNTIME = "$HOME/src/helix/runtime";
      EDITOR = "$HOME/src/helix/target/opt/hx";
      VISUAL = "$HOME/src/helix/target/opt/hx";
      # TERMINAL = "alacritty";
      # BROWSER = "firefox-developer-edition";
    };

    systemPackages = with pkgs; [
      gnumake
      file
      # git-crypt
      gnupg
      less
      wget
      rsync

      picocom

      dua # disk usage
      pass
      tokei

      iptables
      tcpdump

      graphviz
      imagemagick

      # meli

      # tamsyn
      # curie

      usbutils
      pciutils

      cargo-outdated
      zola

      asciinema

      gh # TODO: move to git profile

      libqalculate

      bandwhich
      jless
      xh
      xplr
      bottom
    ];

    # TODO: mutt / aerc
  };

  documentation.dev.enable = true;

  # programs.mosh.enable = true;
  # programs.firejail.enable = true;
}
