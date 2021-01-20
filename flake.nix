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
      # nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
      # nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

      sops-nix.url = "github:Mic92/sops-nix";
      sops-nix.inputs.nixpkgs.follows = "nixpkgs";

      futils.url = "github:numtide/flake-utils/flatten-tree-system";
    };

  outputs = inputs@{ self, home, nixos, nixpkgs, hardware, sops-nix, futils }:
    let
      inherit (builtins) attrNames attrValues readDir;
      inherit (futils.lib) eachDefaultSystem flattenTreeSystem;
      inherit (nixos) lib;
      inherit (lib) recursiveUpdate filterAttrs mapAttrs;
      inherit (utils) pathsToImportedAttrs overlayPaths modules genPackages pkgImport;

      utils = import ./lib/utils.nix { inherit lib; };

      externOverlays = [];
      externModules = [];

      pkgs' = unstable:
        let
          override = import ./pkgs/override.nix;
          overlays = (attrValues self.overlays)
            ++ externOverlays
            ++ [ self.overlay (override unstable) ];
        in
        pkgImport nixos overlays;

      unstable' = pkgImport nixpkgs [ ];

      osSystem = "x86_64-linux";

      outputs =
        let
          system = osSystem;
          unstablePkgs = unstable' system;
          osPkgs = pkgs' unstablePkgs system;
        in
        {
          nixosConfigurations =
            import ./hosts (recursiveUpdate inputs {
              inherit lib osPkgs unstablePkgs utils externModules system;
            });

          overlay = import ./pkgs;

          overlays = pathsToImportedAttrs overlayPaths;

          nixosModules = modules;
        };
    in
    recursiveUpdate
      (eachDefaultSystem
        (system:
          let
            unstablePkgs = unstable' system;
            pkgs = pkgs' unstablePkgs system;

            packages = flattenTreeSystem system
              (genPackages {
                inherit self pkgs;
              });
          in
          {
            inherit packages;

            devShell = import ./shell.nix {
              inherit pkgs;
            };
          }
        )
      )
      outputs;
}
