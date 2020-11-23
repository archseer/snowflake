{ pkgs, ... }: {
  # ./kakoune
  imports = [ ./zsh ];

  home-manager.users.speed = {
    imports = [ ./neovim ./tmux  ];
  };

  environment = {
    shellAliases = {
      v = "$EDITOR";
      c = "cargo";
    };

    sessionVariables = {
      PAGER = "less";
      LESS = "-iFJMRWX -z-4 -x4";
      EDITOR = "nvim";
      VISUAL = "nvim";
      # TERMINAL = "alacritty";
      # BROWSER = "firefox-developer-edition";
    };

    systemPackages = with pkgs; [
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
    ];

     # TODO: mutt / aerc
  };

  documentation.dev.enable = true;

  # programs.mosh.enable = true;
  # programs.firejail.enable = true;
}
