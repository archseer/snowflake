{ stdenv, fetchFromGitHub, kernel }:
let
  version = "acdf1ca329015041ecef1c76e61735008bc128da";
  sha256 = "07xdw2c4j0z2xrq5hwdfdghcziy2dl3kp7lbmprwygb99vw4q7dg";

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
