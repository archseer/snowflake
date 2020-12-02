{ stdenv, buildPackages, fetchurl, linuxManualConfig, pkgs }:
(linuxManualConfig {
  inherit (pkgs.linux_latest) stdenv version src;
  configfile = ./kernel.config;
  kernelPatches = [];
  allowImportFromDerivation = true;
})
.overrideAttrs(o: { # patch the derivation to fix some issues
    nativeBuildInputs = o.nativeBuildInputs ++ [
      pkgs.zlib
      pkgs.zstd # for zstd compression
    ];

    prePatch = o.prePatch + ''
      sed -i scripts/bpf_helpers_doc.py  -e "s|/usr/bin/env python3|${pkgs.buildPackages.python3}/bin/python3|"
    '';
  })
