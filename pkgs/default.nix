final: prev: {
  # https://github.com/colemickens/nixpkgs-wayland/issues/233
  colibri-vim = prev.callPackage ./development/colibri-vim.nix { };
  modprobed-db = prev.callPackage ./misc/modprobed-db.nix {  };

  proggy = prev.callPackage ./development/proggy.nix { };
  curie = prev.callPackage ./development/curie.nix { };
}
