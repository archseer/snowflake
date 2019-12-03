{ stdenv, fetchFromGitHub, kernel }:
let
  version = "414658f8c247e94e5d3f3201dd188e46e078affa";
  sha256 = "1wlvaxx38g3v60qd7w6qy04mymwy86fa0np3m337vd8f3y01lp14";
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

  buildFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -m 755   -d $out/lib/modules/${kernel.modDirVersion}
    cp src/**/*.ko $out/lib/modules/${kernel.modDirVersion}/
  '';

  meta = with stdenv.lib; {
    maintainers = [ "Blaz Hrastnik" ];
    license = [ licenses.gpl2Plus ];
    platforms = [ "x86_64-linux" ];
    broken = versionOlder kernel.version "5.4";
    description = "Linux ACPI and Platform Drivers for Surface Devices using the Surface Aggregator Module over Surface Serial Hub";
    homepage = "https://github.com/linux-surface/surface-aggregator-module";
  };
}
