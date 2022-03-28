{ lib, stdenv, buildPackages, fetchurl, linuxManualConfig, pkgs
, kernelPatches
, linuxPackagesFor
, ... }:
let 
  linux = pkgs.linuxKernel.kernels.linux_5_17;
  # linux = pkgs.callPackage ./linux-5.15.nix {};
in
(linuxManualConfig {
  inherit (linux) stdenv version modDirVersion src;
  inherit lib;
  configfile = ./kernel.config;

  kernelPatches = [
  ]; # TODO: pass through kernelPatches
  allowImportFromDerivation = true;
})
.overrideAttrs(o: { nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.zstd pkgs.zlib ]; }) # for zstd compression
