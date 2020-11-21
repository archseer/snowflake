final: prev: {
  # https://github.com/colemickens/nixpkgs-wayland/issues/233
  rofi-wayland = prev.callPackage ./applications/rofi-wayland.nix { };
  neovim-unwrapped = prev.callPackage ./applications/neovim.nix {
    neovim-unwrapped = prev.neovim-unwrapped;
  };
  # add the surface-aggregator kernel module to all kernel definitions
  linuxPackagesFor = kernel:
    (prev.linuxPackagesFor kernel).extend (final': prev': {
      surface-aggregator = final'.callPackage ./misc/drivers/surface-aggregator {};
    });
}
