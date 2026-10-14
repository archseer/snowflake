{ config, pkgs, ... }:

let
in
{
  home.stateVersion = "22.05";

  imports = [../../profiles/develop/home.nix];

  home.packages =
    [pkgs.ripgrep]
    ++ import ../../profiles/develop/zsh/packages.nix pkgs
    ++ (with pkgs; [
      just

      libfido2
      openssh
    ]);

  # TODO: aerospace

  # TODO: replace homebrew with home-manager config
  # ==> Formulae
  # fzf	helix	pcre2	ripgrep
  # ==> Casks
  # flux			font-cozette		iterm2			karabiner-elements
}
