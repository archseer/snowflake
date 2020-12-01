{ pkgs, ... }: {
  # ./kakoune
  imports = [ ./zsh ];

  home-manager.users.speed = {
    imports = [ ./neovim ./tmux  ];
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

      rustup
      rust-analyzer
    ];

     # TODO: mutt / aerc
  };

  documentation.dev.enable = true;

  # programs.mosh.enable = true;
  # programs.firejail.enable = true;
}
