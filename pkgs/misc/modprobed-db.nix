{ stdenv
, fetchFromGitHub
, pkg-config
, libevdev
, kmod
}:

stdenv.mkDerivation rec {
  pname = "modprobed-db";
  version = "2.44";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = pname;
    rev = "v${version}";
    sha256 = "00fbc0f7a36860fb54caecea1960aa3a907bdd5cf7aa190cbc7584c475e190a3";
  };

  nativeBuildInputs = [ pkg-config ];

  # TODO: sudo optional dep
  buildInputs = [ kmod libevdev ];

  postPatch = ''
    substituteInPlace ./common/modprobed-db.in --replace "/usr/share" "$out/share"
  '';

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/graysky2/modprobed-db";
    description = "Keeps track of EVERY kernel module that has ever been probed. Useful for those of us who make localmodconfig :)";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
