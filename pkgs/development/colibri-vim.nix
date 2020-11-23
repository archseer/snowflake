{ pkgs, lib, fetchFromGitHub, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "colibri-vim";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "archseer";
    repo = "colibri.vim";
    rev = "ad82132e0cbbdfa194d722f15c2df8f0d04b5b71";
    sha256 = "1aknwa8gacinvfq9vnpqx3xjwjl8qddih8cvf878nf2xhp59gff0";
  };
  meta.homepage = "https://github.com/archseer/colibri.vim";
}
