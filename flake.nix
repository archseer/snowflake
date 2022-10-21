{
  description = "My personal config";

  inputs =
    {
      nixos.url = "nixpkgs/nixos-unstable";
      nixpkgs.url = "nixpkgs/nixpkgs-unstable";

      home.url = "github:rycee/home-manager";
      home.inputs.nixpkgs.follows = "nixpkgs";

      hardware.url = "github:NixOS/nixos-hardware";

      mobile-nixos.url = "github:archseer/mobile-nixos/flake";
    };

  outputs = inputs@{ self, home, nixos, nixpkgs, hardware, mobile-nixos }:
    let
      inherit (nixos) lib;
      inherit (lib) recursiveUpdate filterAttrs mapAttrs;
      inherit (utils) overlayPaths modules pkgsFor;

      utils = import ./lib/utils.nix { inherit lib; };

      system = "x86_64-linux";
      
      overlay = import ./pkgs;

      pkgs' = pkgsFor nixos [ overlay ];
      unstable' = pkgsFor nixpkgs [ ];

      outputs =
        let
          unstablePkgs = unstable' system;
          osPkgs = pkgs' system;
        in
        {
          nixosConfigurations =
            import ./hosts (recursiveUpdate inputs {
              inherit lib osPkgs utils system;
            });

          nixosModules = modules;
          
          inherit overlay;

          devShell.${system} = (import ./shell.nix { pkgs = osPkgs; });
        };
    in
    outputs;
}
