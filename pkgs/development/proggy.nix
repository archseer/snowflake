{
  lib,
  stdenv,
  fetchFromGitHub,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "proggyfonts";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "bluescan";
    repo = "proggyfonts";
    rev = "4ea05b4ff3e29ccc77e5d6a10519288882f3582d";
    sha256 = "sha256-yGjrM4L4LMGavqxWdaMC4HrGA9E4fVbLU+vJOxrZc9E=";
  };

  nativeBuildInputs = [ xorg.mkfontscale ];

  postInstall = ''
    install -D -m 644 */*.pcf.gz -t "$out/share/fonts/misc"
    # install -D -m 644 */*.bdf -t "$out/share/fonts/misc"
    install -D -m 644 */*.ttf -t "$out/share/fonts/truetype"
    install -D -m 644 */*.otf -t "$out/share/fonts/opentype"
    install -D -m 644 LICENSE -t "$out/share/doc/$name"

    mkfontscale "$out/share/fonts/truetype"
    mkfontscale "$out/share/fonts/opentype"
    mkfontdir   "$out/share/fonts/misc"
  '';

  meta = with lib; {
    homepage = "http://upperbounds.net";
    description = "A set of fixed-width screen fonts that are designed for code listings";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [maintainers.myrl];
  };
}
