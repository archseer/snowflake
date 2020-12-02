final: prev: {
  # https://github.com/colemickens/nixpkgs-wayland/issues/233
  rofi-wayland = prev.callPackage ./applications/rofi-wayland.nix { };
  colibri-vim = prev.callPackage ./development/colibri-vim.nix { };
  dual-function-keys = prev.callPackage ./dual-function-keys.nix { };
  modprobed-db = prev.callPackage ./misc/modprobed-db.nix {  };
  hyrule-kernel = prev.callPackage ../hosts/hyrule/kernel.nix {  };
  # add the surface-aggregator kernel module to all kernel definitions
  linuxPackagesFor = kernel:
    (prev.linuxPackagesFor kernel).extend (final': prev': {
      surface-aggregator = final'.callPackage ./misc/drivers/surface-aggregator {};
    });
}
