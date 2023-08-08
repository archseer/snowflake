final: prev: {
  # https://github.com/colemickens/nixpkgs-wayland/issues/233
  modprobed-db = prev.callPackage ./misc/modprobed-db.nix {};

  proggy = prev.callPackage ./development/proggy.nix {};
  # curie = prev.callPackage ./development/curie.nix {};
}
