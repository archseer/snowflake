{ lib, pkgs, ... }:
let
  inherit (builtins) concatStringsSep;

  inherit (lib) fileContents;

in
{
  users.defaultUserShell = pkgs.zsh;

  environment = {
    sessionVariables = {
      ZSH_CACHE   = "$XDG_CACHE_HOME/zsh";
    };

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";

      df = "df -h";
      du = "du -h";

      ls = "exa";
      l = "ls -lhg --git";

      ps = "${pkgs.procs}/bin/procs";
    };

    systemPackages = with pkgs; [
      bat
      bzip2
      exa
      fasd
      fd
      fzf
      # gitAndTools.hub
      gzip
      lrzip
      p7zip
      procs
      skim
      unrar
      unzip
      xz
      # zsh-completions
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

      # interactiveShellInit = ''
      #   eval "$(direnv hook zsh)"
      # '';

      initExtra = builtins.readFile ./.zshrc;

      plugins = with pkgs; [
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
          src =  pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        }
      ];
    };

    xdg.configFile."zsh/config" = { source = ./config; recursive = true; };
  };
}
