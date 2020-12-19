{ stdenv, buildPackages, fetchurl, linuxManualConfig, pkgs
, kernelPatches
, ... }:
(linuxManualConfig {
  inherit (pkgs.linux_latest) stdenv version src;
  configfile = ./kernel.config;
  kernelPatches = [
    {
      name = "iio";
      patch = ./iio.patch;
    }
      {
      name = "mt-suspend";
      patch = ./mt-suspend.patch;
    }
  ]; # TODO: pass through kernelPatches
  allowImportFromDerivation = true;
})
.overrideAttrs(o: { nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.zstd ]; }) # for zstd compression
