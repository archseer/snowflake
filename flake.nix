{
  description = "A highly structured configuration database.";

  inputs =
    {
      nixos.url = "nixpkgs/nixos-unstable";
      nixpkgs.url = "nixpkgs/nixpkgs-unstable";

      home.url = "github:rycee/home-manager";
      home.inputs.nixpkgs.follows = "nixpkgs";

      hardware.url = "github:NixOS/nixos-hardware";

      # Wayland overlay
      nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
      nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

      sops-nix.url = "github:Mic92/sops-nix";
      sops-nix.inputs.nixpkgs.follows = "nixpkgs";

      futils.url = "github:numtide/flake-utils";
    };

  outputs = inputs@{ self, home, nixos, nixpkgs, hardware, nixpkgs-wayland, sops-nix, futils }:
    let
      inherit (builtins) attrNames attrValues readDir;
      inherit (nixos) lib;
      inherit (lib) recursiveUpdate;
      inherit (utils) pathsToImportedAttrs overlaysToPkgs;
      inherit (futils.lib) eachSystem defaultSystems;

      utils = import ./lib/utils.nix { inherit lib; };

      systems = defaultSystems ++ [ "armv7l-linux" ];

      pkgImport = pkgs: system:
        import pkgs {
          inherit system;
          overlays = attrValues self.overlays;
          config = { allowUnfree = true; };
        };


      pkgset = system: {
        osPkgs = pkgImport nixos system;
        pkgs = pkgImport nixpkgs system;
      };

      multiSystemOutputs = eachSystem systems (system:
        let
          pkgset' = pkgset system;
        in
        with pkgset';
        {
          devShell = import ./shell.nix {
            inherit pkgs;
          };

          packages = overlaysToPkgs self.overlays osPkgs;
        }
      );

      outputs =
        {
          nixosConfigurations =
            let
              system = "x86_64-linux";
              pkgset' = pkgset system;
            in
            import ./hosts (recursiveUpdate inputs {
              inherit lib system utils;
              pkgset = pkgset';
            }
            );

          nixosModules =
            let
              # binary cache
              cachix = import ./cachix.nix;
              cachixAttrs = { inherit cachix; };

              # modules
              moduleList = import ./modules/list.nix;
              modulesAttrs = pathsToImportedAttrs moduleList;

              # profiles
              profilesList = import ./profiles/list.nix;
              profilesAttrs = { profiles = pathsToImportedAttrs profilesList; };

            in
            recursiveUpdate
              (recursiveUpdate cachixAttrs modulesAttrs)
              profilesAttrs;

          overlay = import ./pkgs;

          overlays =
            let
              overlayDir = ./overlays;
              fullPath = name: overlayDir + "/${name}";
              overlayPaths = map fullPath (attrNames (readDir overlayDir));
            in
            pathsToImportedAttrs overlayPaths;

          defaultTemplate = self.templates.flk;

          templates = {
            flk = {
              path = ./.;
              description = "flk template";
            };
          };
        };
    in
    recursiveUpdate multiSystemOutputs outputs;
}
