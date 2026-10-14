{ config, pkgs, ... }:

let
in
{
  home.stateVersion = "22.05";

  imports = [
    ../../profiles/develop/tmux/home.nix
    ../../profiles/develop/alacritty/home.nix
    ../../profiles/develop/zsh/home.nix
    ../../profiles/develop/git/home.nix
    ../../profiles/develop/jj/home.nix
    ../../profiles/develop/direnv/home.nix
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

    just

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
