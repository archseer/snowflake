{ stdenv, fetchFromGitHub, kernel }:
let
  version = "c933907b663c992183b67c4dbe78c19391d8677e";
  sha256 = "07cp0blmqd2a4cyqgfjacvbrm4m1j5s05hwp9n6516i2aqq8m7r1";
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
    maintainers = [ { name = "Blaž Hrastnik"; email = "blaz@mxxn.io"; } ];
    license = [ licenses.gpl2Plus ];
    platforms = [ "x86_64-linux" ];
    broken = versionOlder kernel.version "5.4";
    description = "Linux ACPI and Platform Drivers for Surface Devices using the Surface Aggregator Module over Surface Serial Hub";
    homepage = "https://github.com/linux-surface/surface-aggregator-module";
  };
}
