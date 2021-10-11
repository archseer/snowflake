{ pkgs, ... }: {
  imports = [ ./zsh ./podman ];
  home-manager.users.speed = {
    imports = [ ./neovim ./tmux ];
  };

  environment = {
    sessionVariables = {
      PAGER = "less";
      LESS = "-iFJMRWX -z-4 -x4";
      EDITOR = "nvim";
      VISUAL = "nvim";
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

      wezterm-bin
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
