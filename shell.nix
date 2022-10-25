{pkgs ? import <nixpkgs> {}}: let
  configs = "${toString ./.}#nixosConfigurations";
  build = "config.system.build";

  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    if [[ -z $1 ]]; then
      echo "Usage: $(basename $0) host {switch|boot|test|iso}"
    elif [[ $1 == "iso" ]]; then
      nix build ${configs}.iso.${build}.isoImage
    else
      sudo -E nix shell -vv ${configs}.$1.${build}.toplevel -c switch-to-configuration $2
    fi
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
