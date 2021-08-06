{ lib, stdenv, fetchFromGitHub, mkfontscale, mkfontdir }:

fetchFromGitHub {
  name = "proggy-2";
  owner = "bluescan";
  repo = "proggyfonts";
  rev = "15812db975e0ab0d810b0f4d2743811d8ef5a47e";
  sha256 = "a0bcbb3cf646c3ff5dbf646a7130f639472670ffb3c2b534ae660776f9fd37a9";

  postFetch =
    ''
      tar xzf $downloadedFile --strip=1
      mkdir -p $out/share/fonts/misc
      install -D -m 644 */*.pcf.gz -t "$out/share/fonts/misc"
      # install -D -m 644 */*.bdf -t "$out/share/fonts/misc"
      install -D -m 644 */*.ttf -t "$out/share/fonts/truetype"
      install -D -m 644 */*.otf -t "$out/share/fonts/opentype"
      install -D -m 644 LICENSE -t "$out/share/doc/$name"

      ${mkfontscale}/bin/mkfontscale "$out/share/fonts/truetype"
      ${mkfontscale}/bin/mkfontscale "$out/share/fonts/opentype"
      ${mkfontdir}/bin/mkfontdir   "$out/share/fonts/misc"
    '';

  meta = with lib; {
    homepage = "http://upperbounds.net";
    description = "A set of fixed-width screen fonts that are designed for code listings";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.myrl ];
  };
}
