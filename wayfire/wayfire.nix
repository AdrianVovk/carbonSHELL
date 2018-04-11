with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "wayfire-${version}";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner  = "ammen99";
    repo   = "wayfire";
    rev    = "789f0e0745f9881837a1cd575e322deb93f4b928";
    sha256 = "1hha6q48qi459nil43k58gyqiwxj7yy54d83qafh3nlxr0abgzip";
  };

#  patchPhase = ''
#    for file in $(ls $src/**/**.hpp); do
#      substituteInPlace $file --replace "#include <compositor.h>" ""
#    done
#  '';

  prePatch = ''
    substituteInPlace plugins/backlight/CMakeLists.txt --replace "SETUID" ""
  '';
  
  enableParallelBuilding = true;
  
  nativeBuildInputs = [ cmake pkgconfig ];
  
  buildInputs = [
    glm glib freetype cairo libevdev alsaLib alsaUtils (import ./weston.nix)
  ];

  cmakeFlags = [
  	"-DUSE_GLES32=False"
  	#"-DCMAKE_INSTALL_PREFIX=/"
  ];

# postConfigure = "cat plugins/backlight/CMakeFiles/intel-util.dir/build.make; exit 1";
}