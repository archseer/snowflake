{ stdenv, fetchFromGitHub, kernel }:
let
  version = "c33c8b7e8101a49b268158205342441eb0bd8c10";
  sha256 = "1vj3hsfydasybzcql362bkbwib81hvbisqznxa585x287d8nj284";
  # version = "bfab2be7d39ea51031d13215a373c9b8dcdab757";
  # sha256 = "1cr19mv9px98l8i263adgb2y1y75kgmlx88fbiw3knyy2bbrgbhf ";
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
