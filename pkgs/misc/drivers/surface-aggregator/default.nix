{ stdenv, fetchFromGitHub, kernel }:
let
  version = "cb2b9507acedd996ad4833ff84ec92123658148b";
  sha256 = "10r5j4k9w2zxbpkw0yq48c4yirjvqdknh1d3vp7gq75i8ki81hrr";

in
stdenv.mkDerivation {
  name = "surface-aggregator-module-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = "surface-aggregator-module";
    rev = version;
    inherit sha256;
  };

  sourceRoot = "source/module";

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/linux-surface/surface-aggregator-module";
    description = "Linux ACPI and Platform Drivers for Surface Devices using the Surface Aggregator Module over Surface Serial Hub";
    license = [ licenses.gpl2Plus ];
    maintainers = [ { name = "Blaž Hrastnik"; email = "blaz@mxxn.io"; } ];
    platforms = [ "x86_64-linux" ];
    broken = versionOlder kernel.version "5.4";
  };
}
