with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "wayfire-${version}";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner  = "ammen99";
    repo   = "wayfire";
    rev    = "2604c88eb87adaa5736d9b8f1acb1b3a983f234b";
    sha256 = "0203wpmj8wh52yqk17xpq4w4ijn6sksgzs25gbwpxbpyp6fgvwxl";
  };

#  patchPhase = ''
#    for file in $(ls $src/**/**.hpp); do
#      substituteInPlace $file --replace "#include <compositor.h>" ""
#    done	
#  '';

  prePatch = ''
  	cp ${import ../shell/shell.nix}/wayland-protocols/*.xml proto/
  	substituteInPlace proto/meson.build --replace "/home/ilex/work/wf-basic-deco/proto/wf-decorator.xml" "wf-decorator.xml"
  '';
  
  enableParallelBuilding = true;
  
  nativeBuildInputs = [ meson ninja pkgconfig ];
  
  buildInputs = [
    glm glib freetype cairo libevdev alsaLib alsaUtils (import ./wlroots.nix)
    #(import ./weston.nix)

        wayland libGLU_combined libxkbcommon cairo xorg.libxcb xorg.libXcursor xlibsWrapper udev libdrm
        mtdev libjpeg pam dbus libinput pango libunwind freerdp libva
        libwebp wayland-protocols
  ];

#  cmakeFlags = [
#  	"-DUSE_GLES32=False"
#  	#"-DCMAKE_INSTALL_PREFIX=/"
#  ];

# postConfigure = "cat plugins/backlight/CMakeFiles/intel-util.dir/build.make; exit 1";
}