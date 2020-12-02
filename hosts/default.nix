{ home
, lib
, hardware
, nixos
, nixpkgs
, pkgset
, self
, system
, utils
, ...
}:
let
  inherit (lib) nameValuePair mapAttrs filterAttrs;
  inherit (builtins) attrValues removeAttrs readDir;
  inherit (pkgset) osPkgs pkgs;

  config = hostName:
    lib.nixosSystem {
      inherit system;

      # pass through to modules
      specialArgs = { inherit hardware; };

      modules =
        let
          inherit (home.nixosModules) home-manager;

          core = self.nixosModules.profiles.core;

          global = {
            networking.hostName = hostName;
            nix.nixPath = let path = toString ../.; in
              [
                "nixpkgs=${nixpkgs}"
                "nixos=${nixos}"
                "nixos-config=${path}/configuration.nix"
                "nixpkgs-overlays=${path}/overlays"
              ];

            nixpkgs = { pkgs = osPkgs; };

            nix.registry = {
              nixos.flake = nixos;
              nixflk.flake = self;
              nixpkgs.flake = nixpkgs;
            };

            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
          };

          overrides = {
            # use latest systemd
            systemd.package = pkgs.systemd;

            nixpkgs.overlays =
              let
                override = import ../pkgs/override.nix pkgs;

                overlay = pkg: final: prev: {
                  "${pkg.pname}" = pkg;
                };
              in
              map overlay override;
          };

          local = import "${toString ./.}/${hostName}";

          # Everything in `./modules/list.nix`.
          flakeModules =
            attrValues (removeAttrs self.nixosModules [ "profiles" ]);

        in
        flakeModules ++ [ core global local home-manager overrides ];

    };

  hosts = 
    mapAttrs
    (n: _: config n)
    (filterAttrs
      (n: v: v == "directory")
      (readDir ./.));
  # hosts = recImport {
  #   dir = ./.;
  #   _import = config;
  # };
in
hosts
