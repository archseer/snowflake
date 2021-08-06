{ lib, stdenv, fetchurl, mkfontscale }:

stdenv.mkDerivation {
  name = "proggy-2";


  src = fetchFromGitHub {
    owner = "bluescan";
    repo = "proggyfonts";
    rev = "15812db975e0ab0d810b0f4d2743811d8ef5a47e";
    sha256 = "1qgimh58hcx5f646gj2kpd36ayvrdkw616ad8cb3lcm11kg0ag79";
  };

  nativeBuildInputs = [ mkfontscale ];

  installPhase =
    ''
      # compress pcf fonts
      mkdir -p $out/share/fonts/misc
      rm Speedy.pcf # duplicated as Speedy11.pcf
      for f in */*.pcf; do
        gzip -n -9 -c "$f" > $out/share/fonts/misc/"$f".gz
      done

      install -D -m 644 */*.bdf -t "$out/share/fonts/misc"
      install -D -m 644 */*.ttf -t "$out/share/fonts/truetype"
      install -D -m 644 */*.otf -t "$out/share/fonts/opentype"
      install -D -m 644 Licence.txt -t "$out/share/doc/$name"

      mkfontscale "$out/share/fonts/truetype"
      mkfontscale "$out/share/fonts/opentype"
      mkfontdir   "$out/share/fonts/misc"
    '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1x196rp3wqjd7m57bgp5kfy5jmj97qncxi1vwibs925ji7dqzfgf";

  meta = with lib; {
    homepage = "http://upperbounds.net";
    description = "A set of fixed-width screen fonts that are designed for code listings";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.myrl ];
  };
}
