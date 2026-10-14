{pkgs ? import <nixpkgs> {}}: let
  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    set -euo pipefail
    if [[ $# -lt 1 ]]; then
      echo "Usage: $(basename "$0") host [switch|boot|test|build] | $(basename "$0") iso"
      exit 1
    fi
    flake=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
    if [[ $1 == iso ]]; then
      exec nix build "$flake#nixosConfigurations.iso.config.system.build.isoImage"
    fi
    exec sudo nixos-rebuild "''${2:-switch}" --flake "$flake#$1"
  '';
in
  pkgs.mkShell {
    name = "nixflk";
    nativeBuildInputs = with pkgs; [
      git
      git-crypt
      nixVersions.stable
      rebuild
    ];

    shellHook = ''
      mkdir -p secrets
      PATH=${
        pkgs.writeShellScriptBin "nix" ''
          ${pkgs.nixVersions.stable}/bin/nix --option experimental-features "nix-command flakes" "$@"
        ''
      }/bin:$PATH
    '';
  }
