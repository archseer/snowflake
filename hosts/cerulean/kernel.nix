{ lib, stdenv, buildPackages, fetchurl, linuxManualConfig, pkgs
, kernelPatches
, ... }:
(linuxManualConfig {
  inherit (pkgs.linux_latest) stdenv version modDirVersion src;
  inherit lib;
  configfile = ./kernel.config;

  kernelPatches = [
    {
      name = "nct2";
      patch = ./nct2.patch;
    }
  ]; # TODO: pass through kernelPatches
  allowImportFromDerivation = true;
})
.overrideAttrs(o: { nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.zstd pkgs.zlib ]; }) # for zstd compression
