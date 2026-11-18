# The full .config for a kernel, generated from Kconfig fragments (see default.nix).
# It's a separate file so scripts/kconfig can build it against another kernel
# without evaluating the kernel itself.
{buildPackages}: {
  fragments,
  linux,
}: let
  inherit (linux) stdenv;
in
  stdenv.mkDerivation {
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

      # Anything that looks like a setting or a requirement but isn't one would be
      # skipped silently.
      malformed=$(grep -hE '^[[:space:]]*(#[[:space:]]*)?(CONFIG_|require)' $fragments \
        | grep -vE '^(CONFIG_[A-Za-z0-9_]+=.*|# CONFIG_[A-Za-z0-9_]+ is not set|# require: CONFIG_[A-Za-z0-9_]+)$' || true)
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

      # `# require: CONFIG_X` lines name options that something else turns on, but
      # that must stay enabled.
      unmet=$(sed -nE 's/^# require: (CONFIG_[A-Za-z0-9_]+)$/\1/p' $fragments | sort -u \
        | while read -r sym; do grep -qE "^$sym=(y|m)$" .config || echo "$sym"; done)
      if [ -n "$unmet" ]; then
        echo "required but not enabled:"; echo "$unmet"; exit 1
      fi

      runHook postBuild
    '';

    installPhase = "cp .config $out";
  }
