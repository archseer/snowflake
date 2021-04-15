{ home
, lib
, hardware
, nixos
, mobile-nixos
, nixpkgs
, osPkgs
, self
, system
, unstablePkgs
, utils
, externModules
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

          # modOverrides = { config, unstableModulesPath, ... }: {
          #   disabledModules = unstableModules ++ addToDisabledModules;
          #   imports = map
          #     (path: "${unstableModulesPath}/${path}")
          #     unstableModules;
          # };

          core = self.nixosModules.profiles.core;

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
          flakeModules =
            attrValues (removeAttrs self.nixosModules [ "profiles" ]);

        in
        flakeModules ++ [
          core global local home-manager
          # modOverrides
        ] ++ externModules;

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
