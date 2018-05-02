with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "wayfire-${version}";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner  = "ammen99";
    repo   = "wayfire";
    rev    = "b17fce10671f16f61b058e77d77a1effb8f235a8";
    sha256 = "0d5lpknlpasjjd144jw6wl7lf363jqhvpwajcvc05lzmpldzqr6l";
  };

  prePatch = ''
  	#cp ${import ../shell}/wayland-protocols/*.xml proto/
  	#substituteInPlace proto/meson.build --replace "/home/ilex/work/wf-basic-deco/proto/wf-decorator.xml" "wf-decorator.xml"

  	# HACK: Make decoration only work with xwayland.
  	substituteInPlace plugins/decor/decoration.cpp --replace "if (decorator_resource && !decorator.is_decoration_window(view->get_title()))" "if (decorator_resource && !decorator.is_decoration_window(view->get_title()) && wlr_surface_is_xwayland_surface(view->surface))"
  	substituteInPlace plugins/decor/meson.build --replace "dependencies: [pixman, wf_protos]," "dependencies: [pixman, wf_protos, wlroots],"
  	substituteInPlace plugins/decor/decoration.cpp --replace '#include "wf-decorator-protocol.h"' "#include \"wf-decorator-protocol.h\"
  	extern \"C\" {
  	#define class class_t
  	#include <wlr/xwayland.h>
  	#undef class
  	}"

  	cat plugins/decor/decoration.cpp
  '';
  
  enableParallelBuilding = true;
  
  nativeBuildInputs = [ meson ninja pkgconfig ];

  mesonFlags = [ "--buildtype=debug" ];
  
  buildInputs = [
    glm glib freetype cairo libevdev alsaLib alsaUtils (import ./wlroots.nix)
	xwayland

    wayland libGLU_combined libxkbcommon cairo xorg.libxcb xorg.libXcursor xlibsWrapper udev libdrm
    mtdev libjpeg pam dbus libinput pango libunwind freerdp libva
    libwebp wayland-protocols
  ];
}