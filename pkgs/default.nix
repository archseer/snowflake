final: prev: {
  # https://github.com/colemickens/nixpkgs-wayland/issues/233
  rofi-wayland = prev.callPackage ./applications/rofi-wayland.nix { };
  neovim-unwrapped = prev.callPackage ./applications/neovim.nix {
    neovim-unwrapped = prev.neovim-unwrapped;
  };
  linuxPackagesFor = kernel: prev.lib.makeExtensible (self: with self; {
    surface-aggregator = prev.callPackage ./misc/drivers/surface-aggregator {
      inherit kernel;
      # withDriver = true;
    };
  });
}
