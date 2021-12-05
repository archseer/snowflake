{ lib
, stdenv
, rofi
, fetchFromGitHub
, meson
, ninja
, pkg-config
, bison
, check
, flex
, librsvg
, libstartup_notification
, libxkbcommon
, pango
, wayland
, wayland-protocols
, xcbutilwm
, xcbutilxrm
, xcb-util-cursor
}:

rofi.override {
  rofi-unwrapped = stdenv.mkDerivation rec {
    pname = "rofi-wayland";
    version = "1.7.1+wayland1-dev";

    src = fetchFromGitHub {
      owner = "lbonn";
      repo = "rofi";
      rev = "a2a1c89df846eabeb8e2e7ad7c7beb6d23e11d86";
      sha256 = "sha256-adTHy37sg2NcxPbuXKihMLYGN2H9JUS+sOHW1qZphO4=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      ninja
      meson
      pkg-config
    ];

    buildInputs = [
      bison
      check
      flex
      librsvg
      libstartup_notification
      libxkbcommon
      pango
      wayland
      wayland-protocols
      xcbutilwm
      xcbutilxrm
      xcb-util-cursor      
    ];

    mesonFlags = [
      "-Dwayland=enabled"
    ];

    # Fixes:
    # ../source/rofi-icon-fetcher.c:190:17: error: format not a string literal and no format arguments [-Werror=format-security]
    hardeningDisable = [ "format" ];

    doCheck = true;

    meta = with lib; {
      description = "Window switcher, run dialog and dmenu replacement (built for Wayland)";
      homepage = "https://github.com/lbonn/rofi";
      license = licenses.mit;
      maintainers = with maintainers; [ metadark ];
      platforms = platforms.linux;
    };
  };
}
