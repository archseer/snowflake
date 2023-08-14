{
  stdenv,
  lib,
  fetchzip,
  mkfontdir,
}:
stdenv.mkDerivation rec {
  name = "curie-${version}";
  version = "v1.0";

  src = fetchzip {
    url = "https://github.com/NerdyPepper/curie/releases/download/${version}/${name}.tar.gz";
    sha256 = "0b0m22pdbh39dshz5dq5vcjqzjvbyxcmlpadvgfkl60989wfs53q";
    stripRoot = false;
  };

  nativeBuildInputs = [mkfontdir];

  installPhase = ''
    install -m 644 -Dt "$out/share/fonts/misc" *.otb
    install -m444 -Dt $out/share/doc/${name} README.md LICENSE
    mkfontdir "$out/share/fonts/misc"
  '';

  meta = with lib; {
    description = "A slightly upscaled version of scientifica";
    homepage = "https://github.com/NerdyPepper/curie";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
