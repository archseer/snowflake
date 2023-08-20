{
  pkgs,
  ...
}: {
  users.defaultUserShell = pkgs.zsh;

  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;

  environment = {
    sessionVariables = {
    };

    systemPackages = with pkgs; [
      bat
      bzip2
      exa
      fd
      fzf
      gzip
      lrzip
      p7zip
      procs
      skim
      # unrar
      unzip
      xz
      xdg-utils
    ];
  };

  home-manager.users.speed = {
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      # I init completion myself, because enableCompletion initializes it
      # too soon, which means commands initialized later in my config won't get
      # completion, and running compinit twice is slow.
      enableCompletion = false;
      # promptInit = "";

      defaultKeymap = "viins";

      dotDir = ".config/zsh";

      initExtra = builtins.readFile ./zshrc;

      shellAliases = {
        v = "$EDITOR";
        c = "cargo";

        cat = "${pkgs.bat}/bin/bat";

        df = "df -h";
        du = "du -h";

        g = "${pkgs.git}/bin/git";

        e = "v $(fzf)";

        l = "exa -lahgF --group-directories-first";
        # --time-style=long-iso
        ll = "exa -F";

        # j stands for jump
        j = "z";

        open = "${pkgs.xdg-utils}/bin/xdg-open";
        ps = "${pkgs.procs}/bin/procs";
      };

      plugins = [
        # {
        #   name = "zsh-history-substring-search";
        #   src = zsh-history-substring-search;
        #   file = "share/zsh/site-functions/zsh-history-substring-search.plugin.zsh"
        # }
        {
          name = "zsh-completions";
          src = pkgs.zsh-completions;
          file = "share/zsh/site-functions/zsh-completions.plugin.zsh";
        }
        {
          name = "fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        }
      ];
    };

    xdg.configFile."zsh/config" = {
      source = ./config;
      recursive = true;
    };

    programs.fzf = {
      enable = true;

      # fd > find
      defaultOptions = ["--reverse" "--ansi"]; # FZF_DEFAULT_OPTS
      defaultCommand = "fd ."; # FZF_DEFAULT_COMMAND
      fileWidgetCommand = "fd ."; # FZF_CTRL_T_COMMAND
      changeDirWidgetCommand = "fd --type d . $HOME"; # FZF_ALT_C_COMMAND
    };

    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        workspace = true;
        # TODO: auto_sync etc
        update_check = false;
      };

    };
    programs.zoxide.enable = true;
  };
}
