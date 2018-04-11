with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "foo-${version}";
  version = "0.0.0";

  src = ./src;
  phases = [ "buildPhase" "installPhase" ];
  nativeBuildInputs = [ vala pkgconfig ];
  buildInputs = [ gtk3 ];
  buildPhase = "valac -o output --pkg gtk+-3.0 $src/**";
  installPhase = "mkdir -p $out/bin && cp ./output $out/bin/test";
}