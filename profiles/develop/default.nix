{ pkgs, ... }: {
  imports = [ ./zsh ./podman ];
  home-manager.users.speed = {
    imports = [ ./neovim ./tmux ];
  };

  environment = {
    sessionVariables = {
      PAGER = "less";
      LESS = "-iFJMRWX -z-4 -x4";
      HELIX_RUNTIME="$HOME/src/helix/runtime";
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
      
      kakoune

      wezterm
      tamsyn
      curie

      usbutils

      rustup
      cargo-outdated

      asciinema

      # language servers
      rust-analyzer
      clang-tools

      # nixpkgs-fmt
      # nix-linter

      # dhall dhall-lsp-server
    ];

     # TODO: mutt / aerc
  };

  documentation.dev.enable = true;

  # programs.mosh.enable = true;
  # programs.firejail.enable = true;
}
