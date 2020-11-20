{ lib, pkgs, ... }:
let
  inherit (builtins) concatStringsSep;

  inherit (lib) fileContents;

in
{
  users.defaultUserShell = pkgs.zsh;

  environment = {
    sessionVariables = {
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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = ["git" "rust" "cargo" "docker" "gitignore" "systemd" "vi-mode" "fasd" ];
      customPkgs = with pkgs;[
        spaceship-prompt
        nix-zsh-completions
      ];
      theme = "spaceship";
    };
    interactiveShellInit = ''
      SPACESHIP_DOCKER_SHOW=false
      eval "$(direnv hook zsh)"
    '';
  };
}
