{
  description = "My personal config";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home.url = "github:rycee/home-manager";
    home.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:NixOS/nixos-hardware";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    mobile-nixos.url = "github:archseer/mobile-nixos/flake";
  };

  outputs = inputs @ {
    self,
    home,
    nixos,
    nixpkgs,
    hardware,
    disko,
    mobile-nixos,
    darwin,
  }: let
    inherit (builtins) attrValues;
    inherit (nixos) lib;

    pkgsFor = nixpkgs: overlays: system:
      import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

    system = "x86_64-linux";

    overlay = import ./pkgs;

    pkgs' = pkgsFor nixos [overlay];
    # unstable' = pkgsFor nixpkgs [];

    mkSystem = pkgs: system: hostName: let
      # unstablePkgs = unstable' system;
      osPkgs = pkgs' system;
    in
      pkgs.lib.nixosSystem {
        inherit system;

        # pass through to modules
        specialArgs = {inherit inputs;};

        modules = let
          inherit (home.nixosModules) home-manager;

          core = ./profiles/core;

          global = {
            networking.hostName = hostName;
            nix.nixPath = let
              path = toString ./.;
            in [
              "nixpkgs=${nixpkgs}"
              "nixos=${nixos}"
              "nixos-config=${path}/configuration.nix"
              "home-manager=${home}"
            ];

            nixpkgs.pkgs = osPkgs;

            # conflicts definition below
            nixpkgs.flake.setNixPath = false;
            nixpkgs.flake.setFlakeRegistry = false;

            nix.registry = {
              nixpkgs.flake = nixpkgs;
              snowflake.flake = self;
              nixos.flake = nixos;
              home-manager.flake = home;
            };

            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
          };

          local = import ./hosts/${hostName};

          # Everything in `./modules/list.nix`.
          flakeModules = attrValues self.nixosModules;
        in
          flakeModules
          ++ [
            core
            global
            local
            home-manager
            disko.nixosModules.disko
          ];
      };

    outputs = {
      nixosConfigurations = {
        cerulean = mkSystem nixos system "cerulean";
        trantor = mkSystem nixos system "trantor";
        hyrule = mkSystem nixos system "hyrule";
        aldhani = mkSystem nixos system "aldhani";
        corrin = mkSystem nixos "aarch64-linux" "corrin";
        iso = mkSystem nixos system "iso";
      };

      darwinConfigurations = {
        "m4-macbook" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/m4-macbook/configuration.nix
            home.darwinModules.home-manager
            {
              nixpkgs = { config.allowUnfree = true; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.blazhrastnik = import ./hosts/m4-macbook/home.nix;
            }
          ];
        };
      };

      nixosModules = {};

      inherit overlay;

      devShell.${system} = import ./shell.nix {pkgs = pkgs' system;};

      formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    };
  in
    outputs;
}
