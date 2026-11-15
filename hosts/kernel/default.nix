# kernel built from Kconfig fragments
#
# The fragments list deliberate choices only, every other option gets its
# Kconfig default from `make olddefconfig`. The build fails if two fragments
# set the same symbol or if a requested value doesn't make it into the final
# config.
#
# Lines other than `CONFIG_X=...` and `# CONFIG_X is not set` are comments.
{
  lib,
  buildPackages,
  linuxKernel,
  linuxManualConfig,
}: {
  fragments,
  linux ? linuxKernel.kernels.linux_7_3,
}: let
  inherit (linux) stdenv;

  configfile = stdenv.mkDerivation {
    pname = "linux-config";
    inherit (linux) version src;

    depsBuildBuild = [buildPackages.stdenv.cc];
    # The same toolchain probes as the kernel build: without pahole,
    # olddefconfig silently drops DEBUG_INFO_BTF and with it sched_ext.
    nativeBuildInputs = with buildPackages; [bc bison flex openssl perl pahole];

    fragments = map (f: "${f}") fragments;

    postPatch = "patchShebangs scripts";
    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      settings() { grep -hE '^(CONFIG_[A-Za-z0-9_]+=|# CONFIG_[A-Za-z0-9_]+ is not set$)' "$@" || true; }
      symbols() { sed -E 's/^# (CONFIG_[A-Za-z0-9_]+) is not set$/\1/; s/=.*//'; }

      # Anything that looks like a setting but isn't one would be skipped silently.
      malformed=$(grep -hE '^[[:space:]]*(#[[:space:]]*)?CONFIG_' $fragments \
        | grep -vE '^(CONFIG_[A-Za-z0-9_]+=.*|# CONFIG_[A-Za-z0-9_]+ is not set)$' || true)
      if [ -n "$malformed" ]; then
        echo "malformed lines:"; echo "$malformed"; exit 1
      fi

      dups=$(settings $fragments | symbols | sort | uniq -d)
      if [ -n "$dups" ]; then
        echo "set in more than one fragment:"; echo "$dups"; exit 1
      fi

      settings $fragments > .config
      make ARCH=${stdenv.hostPlatform.linuxArch} olddefconfig

      missing=$(settings $fragments | sort -u | comm -23 - <(sort .config))
      if [ -n "$missing" ]; then
        echo "requested but not in the final config:"; echo "$missing"; exit 1
      fi

      runHook postBuild
    '';

    installPhase = "cp .config $out";
  };

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
