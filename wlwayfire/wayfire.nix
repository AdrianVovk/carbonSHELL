with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "wayfire-${version}";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner  = "ammen99";
    repo   = "wayfire";
    rev    = "04f1ae262bdf664034af78d63808575e6ad773d6";
    sha256 = "0k4sr8vi95gyw3gh71i91ipzpqdbycj7c7bmjjvdz73zjy85g67j";
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
    glm glib freetype cairo libevdev alsaLib alsaUtils (import ./weston.nix) (import ./wlroots.nix)
  ];

#  cmakeFlags = [
#  	"-DUSE_GLES32=False"
#  	#"-DCMAKE_INSTALL_PREFIX=/"
#  ];

# postConfigure = "cat plugins/backlight/CMakeFiles/intel-util.dir/build.make; exit 1";
}