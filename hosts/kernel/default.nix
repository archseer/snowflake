# kernel built from Kconfig fragments
#
# The fragments list deliberate choices only, every other option gets its
# Kconfig default from `make olddefconfig`. The build fails if two fragments
# set the same symbol or if a requested value doesn't make it into the final
# config.
#
# A `# require: CONFIG_X` line fails the build unless X ends up enabled, for
# options that something else turns on but that userspace depends on.
#
# Lines other than `CONFIG_X=...`, `# CONFIG_X is not set` and `# require: CONFIG_X`
# are comments.
{
  lib,
  buildPackages,
  linuxKernel,
  linuxManualConfig,
}: {
  fragments,
  linux ? linuxKernel.kernels.linux_7_3,
}: let
  configfile = import ./config.nix {inherit buildPackages;} {inherit fragments linux;};

  kernel = linuxManualConfig {
    inherit (linux) stdenv version modDirVersion src;
    inherit lib configfile;
    allowImportFromDerivation = true;
    # Read by NixOS assertions, so derive them from the real config.
    features = {
      efiBootStub = kernel.config.isYes "EFI_STUB";
      ia32Emulation = kernel.config.isYes "IA32_EMULATION";
      netfilterRPFilter = kernel.config.isEnabled "IP_NF_MATCH_RPFILTER";
    };
  };
in
  kernel
