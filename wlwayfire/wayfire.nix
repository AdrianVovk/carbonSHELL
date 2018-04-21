with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "wayfire-${version}";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner  = "ammen99";
    repo   = "wayfire";
    rev    = "wlroots-adrian";
    sha256 = "19bi6jp60q07nwzxsgyfv8xmr209hkxhyirzy4qacl3sx6z64vak";
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
    (import ./weston.nix)

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