{pkgs, ...}: {
  imports = [./zsh ./podman];
  home-manager.users.speed = {
    imports = [./neovim ./tmux];
  };

  # qmk rules
  services.udev.extraRules = ''
    # UDEV rules for Teensy USB devices
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"
  '';

  environment = {
    sessionVariables = {
      PAGER = "less";
      LESS = "-iFJMRWX -z-4 -x4";
      HELIX_RUNTIME = "$HOME/src/helix/runtime";
      EDITOR = "$HOME/src/helix/target/release/hx";
      VISUAL = "$HOME/src/helix/target/release/hx";
      # TERMINAL = "alacritty";
      # BROWSER = "firefox-developer-edition";
    };

    systemPackages = with pkgs; [
      gnumake
      clang
      lld
      file
      git-crypt
      gnupg
      less
      dua # disk usage
      pass
      tig
      tokei
      wget
      picocom
      rsync

      nix-du
      graphviz
      imagemagick

      kakoune
      # meli

      wezterm
      tamsyn
      curie

      usbutils

      rustup
      cargo-outdated
      zola

      asciinema

      gource

      # language servers
      rust-analyzer
      clang-tools

      gh

      # nixpkgs-fmt
      # nix-linter

      # dhall dhall-lsp-server

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
