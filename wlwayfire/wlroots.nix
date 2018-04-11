with import <nixpkgs> {};

let pname = "wlroots";
    version = "unstable-2018-04-08";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "wlroots";
    rev = "5f48c7fddd6a28b529eb02ca156db577b76edfb6";
    sha256 = "0jldmp5zgndyiz9bqxxck60910gb1i42pgfzvaxh97rgj4jhhkz8";
  };

  # $out for the library and $bin for rootston
  outputs = [ "out" "bin" ];

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [
    wayland libGL wayland-protocols libinput libxkbcommon pixman
    xorg.xcbutilwm xorg.libX11 libcap xorg.xcbutilimage xorg.xcbutilerrors
  ];

  # Install rootston (the reference compositor) to $bin
  postInstall = ''
    mkdir -p $bin/bin
    cp rootston/rootston $bin/bin/
    mkdir $bin/lib
    cp libwlroots* $bin/lib/
    patchelf --set-rpath "$bin/lib:${stdenv.lib.makeLibraryPath buildInputs}" $bin/bin/rootston
    mkdir $bin/etc
    cp ../rootston/rootston.ini.example $bin/etc/rootston.ini
  '';

  meta = with stdenv.lib; {
    description = "A modular Wayland compositor library";
    inherit (src.meta) homepage;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
