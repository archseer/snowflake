{ pkgs, ... }: {
  # ./kakoune
  imports = [ ./zsh ./neovim ./tmux ];

  environment.shellAliases = { v = "$EDITOR"; };

  environment.sessionVariables = {
    PAGER = "less";
    LESS = "-iFJMRWX -z-4 -x4";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.systemPackages = with pkgs; [
    clang
    lld
    file
    git-crypt
    gnupg
    less
    ncdu
    pass
    tig
    tokei
    wget
    fzf
  ];

  # documentation.dev.enable = true;

  # Already opens ports for us
  # programs.mosh.enable = true;

  # programs.firejail.enable = true;
}
