{ fetchurl, pkgs, dbus, egl-wayland, fetchFromGitHub, fontconfig, freetype, lib
, libGL, libGLU, libX11, libglvnd # libEGL.so.1
, libiconv, libxcb, libxkbcommon, openssl, perl, pkg-config, python3
, rustPlatform, stdenv, wayland, xcbutil, xcbutilimage, xcbutilkeysyms
, xcbutilwm # contains xcb-ewmh among others
, zlib

}:

let
  rpath = lib.makeLibraryPath [
    dbus
    egl-wayland
    fontconfig
    fontconfig.lib
    freetype
    libGL
    libGLU
    libglvnd
    libxkbcommon
    openssl
    wayland
    libX11
    libxcb
    xcbutil
    xcbutilimage
    xcbutilkeysyms
    xcbutilwm
    zlib

  ];

in stdenv.mkDerivation rec {
  pname = "wezterm-bin";
  version = "nightly-2022";

  src = fetchurl {
    url =
      "https://github.com/wez/wezterm/releases/download/nightly/wezterm-nightly.Ubuntu16.04.tar.xz";
    sha256 = "sha256-JjcKgoez1bh2JUgi4MUUdjeZmBorlSOvFE+v+69SEqw=";
  };

  nativeBuildInputs = [ pkg-config python3 perl ];

  # prevent further changes to the RPATH
  dontPatchELF = true;

  installPhase = ''
     mkdir -p $out
    cp -r ./usr/* $out/
  '';

  postFixup = ''
    for artifact in wezterm wezterm-gui wezterm-mux-server strip-ansi-escapes; do
     patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/bin/$artifact" || true
     patchelf --set-rpath "${rpath}" $out/bin/$artifact
    done
  '';

  meta = with lib; {
    description = "Wezterm terminal (pre-compiled binary version)";
    homepage = "https://github.com/wez/wezterm";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.pinpox ];
    platforms = platforms.all;
  };
}
