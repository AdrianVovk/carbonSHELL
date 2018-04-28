with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "wayfire-${version}";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner  = "ammen99";
    repo   = "wayfire";
    rev    = "edc03e1e423c7cad61102533e011a082c08dc9b8";
    sha256 = "16l33rcal0h3rywg5bgls88k0my5cz9648cp2mr2xa7ywr2w6bg2";
  };

  prePatch = ''
  	cp ${import ../shell/shell.nix}/wayland-protocols/*.xml proto/
  	substituteInPlace proto/meson.build --replace "/home/ilex/work/wf-basic-deco/proto/wf-decorator.xml" "wf-decorator.xml"
  '';
  
  enableParallelBuilding = true;
  
  nativeBuildInputs = [ meson ninja pkgconfig ];

  # mesonFlags = [ "--buildtype=debug" ];
  
  buildInputs = [
    glm glib freetype cairo libevdev alsaLib alsaUtils (import ./wlroots.nix)
	xwayland

    wayland libGLU_combined libxkbcommon cairo xorg.libxcb xorg.libXcursor xlibsWrapper udev libdrm
    mtdev libjpeg pam dbus libinput pango libunwind freerdp libva
    libwebp wayland-protocols
  ];
}