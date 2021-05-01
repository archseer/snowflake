{ lib, stdenv, buildPackages, fetchurl, linuxManualConfig, pkgs
, kernelPatches
, linuxPackagesFor
, ... }:
let 
  # linux = pkgs.linux_latest;
  linux = pkgs.callPackage ./linux-5.12.nix {};
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
