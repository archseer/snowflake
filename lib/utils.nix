{lib, ...}: let
  inherit (builtins) attrNames attrValues isAttrs readDir listToAttrs mapAttrs;

  inherit
    (lib)
    fold
    filterAttrs
    hasSuffix
    mapAttrs'
    nameValuePair
    removeSuffix
    recursiveUpdate
    genAttrs
    ;

  # Generate an attribute set by mapping a function over a list of values.
  genAttrs' = values: f: listToAttrs (map f values);

  pkgsFor = nixpkgs: overlays: system:
    import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

  # Convert a list to file paths to attribute set
  # that has the filenames stripped of nix extension as keys
  # and imported content of the file as value.
  pathsToImportedAttrs = paths:
    genAttrs' paths (path: {
      name = removeSuffix ".nix" (baseNameOf path);
      value = import path;
    });
in {
  inherit genAttrs' pkgsFor pathsToImportedAttrs;

  overlayPaths = let
    overlayDir = ../overlays;
    fullPath = name: overlayDir + "/${name}";
  in
    map fullPath (attrNames (readDir overlayDir));

  modules = let
    # binary cache
    cachix = import ../cachix.nix;
    cachixAttrs = {inherit cachix;};

    # modules
    moduleList = import ../modules/list.nix;
    modulesAttrs = pathsToImportedAttrs moduleList;
  in
    recursiveUpdate cachixAttrs modulesAttrs;
}
