final: prev:
let
  linux_5_9 = prev.linuxPackages_5_9.kernel;
in
{
  surface-kernel = (prev.linuxManualConfig {
    inherit (linux_5_9) src stdenv version;
    # version = "${linux_5_9.version}-surface";

    configfile = ../kernel.config;
    allowImportFromDerivation = true;
  }).overrideAttrs(o: {
    nativeBuildInputs = o.nativeBuildInputs ++ [
      prev.zlib
      prev.zstd # for zstd compression
    ];
    prePatch = o.prePatch + ''
      sed -i scripts/bpf_helpers_doc.py  -e "s|/usr/bin/env python3|${prev.buildPackages.python3}/bin/python3|"
    '';
  });
  linuxPackages_surface = prev.linuxPackagesFor final.surface-kernel;
}
