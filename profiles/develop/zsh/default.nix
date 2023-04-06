{
  pkgs,
  ...
}: {
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  environment = {
    sessionVariables = {
    };

    systemPackages = with pkgs; [
      bat
      bzip2
      exa
      fasd
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

      dotDir = ".config/zsh";

      initExtra = builtins.readFile ./.zshrc;

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
        j = "fasd_cd -d";

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
  };
}
