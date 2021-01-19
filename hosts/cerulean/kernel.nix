{ stdenv, buildPackages, fetchurl, linuxManualConfig, pkgs
, kernelPatches
, ... }:
(linuxManualConfig {
  inherit (pkgs.linux_latest) stdenv version src;
  configfile = ./kernel.config;
  kernelPatches = [
    {
      name = "nct1";
      patch = ./nct1.patch;
    }
    {
      name = "nct2";
      patch = ./nct2.patch;
    }
  ]; # TODO: pass through kernelPatches
  allowImportFromDerivation = true;
})
.overrideAttrs(o: { nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.zstd pkgs.zlib ]; }) # for zstd compression
