{ lib, ... }:
let
  inherit (builtins) attrNames attrValues isAttrs readDir listToAttrs;

  inherit (lib)
    collect
    filterAttrs
    filterAttrsRecursive
    getName
    hasSuffix
    isDerivation
    mapAttrs'
    mapAttrs
    nameValuePair
    removeSuffix;

  # mapFilterAttrs ::
  #   (name -> value -> bool )
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = seive: f: attrs: filterAttrs seive (mapAttrs' f attrs);

  # Generate an attribute set by mapping a function over a list of values.
  genAttrs' = values: f: listToAttrs (map f values);

in
{
  inherit mapFilterAttrs genAttrs';

  recImport = { dir, _import ? base: import "${dir}/${base}.nix" }:
    mapFilterAttrs
      (_: v: v != null)
      (n: v:
        if n != "default.nix" && hasSuffix ".nix" n && v == "regular"
        then
          let name = removeSuffix ".nix" n; in nameValuePair (name) (_import name)

        else
          nameValuePair ("") (null))
      (readDir dir);

  # Convert a list to file paths to attribute set
  # that has the filenames stripped of nix extension as keys
  # and imported content of the file as value.
  pathsToImportedAttrs = paths:
    genAttrs' paths (path: {
      name = removeSuffix ".nix" (baseNameOf path);
      value = import path;
    });

  overlaysToPkgs = overlaysAttrs: pkgs:
    let
      overlayDrvs = mapAttrs (_: v: v pkgs pkgs) overlaysAttrs;

      # some derivations fail to evaluate, simply remove them so we can move on
      filterDrvs = filterAttrsRecursive
        (_: v: (builtins.tryEval v).success)
        overlayDrvs;

      drvs = collect (isDerivation) filterDrvs;

      # don't bother exporting a package if it's platform isn't supported
      systemDrvs = builtins.filter
        (drv: builtins.elem
          pkgs.system
          (drv.meta.platforms or [ ]))
        drvs;

      nvPairs = map
        (drv: nameValuePair (getName drv) drv)
        systemDrvs;
    in
    listToAttrs nvPairs;

}
