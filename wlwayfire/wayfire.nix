with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "wayfire-${version}";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner  = "ammen99";
    repo   = "wayfire";
    rev    = "b1514c96a3732e556c9e50aa9ad45231ec9e3ff3";
    sha256 = "12vkacjcd3czfya00h6nlb4gihqdy4d94d6fvp4i9zwq7k72ix0r";
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