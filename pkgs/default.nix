final: prev: {
  # https://github.com/colemickens/nixpkgs-wayland/issues/233
  rofi-wayland = prev.callPackage ./applications/rofi-wayland.nix { };
  colibri-vim = prev.callPackage ./development/colibri-vim.nix { };
  dual-function-keys = prev.callPackage ./dual-function-keys.nix { };
  modprobed-db = prev.callPackage ./misc/modprobed-db.nix {  };

  proggy = prev.callPackage ./development/proggy.nix { };
  curie = prev.callPackage ./development/curie.nix { };
}
