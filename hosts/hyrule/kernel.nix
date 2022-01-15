{ lib, stdenv, buildPackages, fetchurl, linuxManualConfig, pkgs
, kernelPatches
, ... }:
(linuxManualConfig {
  inherit (pkgs.linuxKernel.packageAliases.linux_5_16.kernel) stdenv version src;
  inherit lib;
  configfile = ./kernel.config;
  kernelPatches = [
  ]; # TODO: pass through kernelPatches
  allowImportFromDerivation = true;
})
.overrideAttrs(o: { nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.zstd pkgs.zlib ]; }) # for zstd compression
