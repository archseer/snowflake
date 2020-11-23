{ pkgs, lib, fetchFromGitHub, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "colibri-vim";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "archseer";
    repo = "colibri.vim";
    rev = "ad82132e0cbbdfa194d722f15c2df8f0d04b5b71";
    sha256 = "0r4xs0mhdxvac81cly89jqnby14h1dmrpkdfs0chz5ji4gbsgair";
  };
  meta.homepage = "https://github.com/archseer/colibri.vim";
}
