{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  linuxManualConfig,
  pkgs,
  kernelPatches,
  ...
}: let
  linux = pkgs.linuxKernel.kernels.linux_6_2;
  # linux = pkgs.callPackage ./linux-6.1.nix {};

  kernel =
    (linuxManualConfig {
      inherit (linux) stdenv version modDirVersion src;
      inherit lib;
      configfile = ./kernel.config;
      kernelPatches = [
      ]; # TODO: pass through kernelPatches
      allowImportFromDerivation = true;
    })
    .overrideAttrs (o: {nativeBuildInputs = o.nativeBuildInputs ++ [pkgs.zstd pkgs.zlib];}); # for zstd compression

  passthru = {
    # TODO: confirm all these stil apply
    features = {
      iwlwifi = true;
      efiBootStub = true;
      needsCifsUtils = true;
      netfilterRPFilter = true;
      ia32Emulation = true;
    };
  };

  finalKernel = lib.extendDerivation true passthru kernel;
in
  finalKernel
