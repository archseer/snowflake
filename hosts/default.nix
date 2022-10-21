{ home
, lib
, hardware
, nixos
, mobile-nixos
, nixpkgs
, osPkgs
, self
, system
, utils
, ...
}:
let
  inherit (lib) nameValuePair mapAttrs filterAttrs;
  inherit (builtins) attrValues removeAttrs readDir;

  config = hostName:
    lib.nixosSystem {
      inherit system;

      # pass through to modules
      specialArgs = { inherit hardware mobile-nixos; };

      modules =
        let
          inherit (home.nixosModules) home-manager;

          core = ../profiles/core;

          global = {
            networking.hostName = hostName;
            nix.nixPath = let path = toString ../.; in
              [
                "nixpkgs=${nixpkgs}"
                "nixos=${nixos}"
                "nixos-config=${path}/configuration.nix"
                "nixpkgs-overlays=${path}/overlays"
                "home-manager=${home}"
              ];

            nixpkgs.pkgs = osPkgs;

            nix.registry = {
              nixpkgs.flake = nixpkgs;
              snowflake.flake = self;
              nixos.flake = nixos;
              home-manager.flake = home;
            };

            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
          };

          local = import "${toString ./.}/${hostName}";

          # Everything in `./modules/list.nix`.
          flakeModules = (attrValues self.nixosModules);

        in
        flakeModules ++ [
          core global local home-manager
        ];

    };

  hosts = 
    mapAttrs
    (n: _: config n)
    (filterAttrs
      (n: v: v == "directory")
      (readDir ./.));
in
hosts
