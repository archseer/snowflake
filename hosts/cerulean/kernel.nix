{ lib, stdenv, buildPackages, fetchurl, linuxManualConfig, pkgs
, kernelPatches
, linuxPackagesFor
, ... }:
let 
  linux = pkgs.linux_5_14;
  # linux = pkgs.callPackage ./linux-5.14.nix {};
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
