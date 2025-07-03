{ config, pkgs, ... }:

let
in
{
  home.stateVersion = "22.05";

  imports = [
    ../../profiles/develop/tmux
    ../../profiles/develop/alacritty
    ../../profiles/develop/zsh/home.nix
    ../../users/profiles/git
    ../../users/profiles/jj
    ../../users/profiles/direnv
  ];

  home.packages = with pkgs; [
    ripgrep
    # TODO: share with develop/zsh/default
    bat
    eza
    sd
    fd
    fzf
    skim
    procs

    libfido2
    openssh
  ];

  # TODO: aerospace

  # TODO: replace homebrew with home-manager config
  # ==> Formulae
  # fzf	helix	pcre2	ripgrep
  # ==> Casks
  # flux			font-cozette		iterm2			karabiner-elements
}
