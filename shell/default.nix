with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "carbon-shell-${version}";
  version = "0.0.0";

  src = ./src;
  phases = [ "buildPhase" "installPhase" ];
  nativeBuildInputs = [ vala pkgconfig ];
  buildInputs = [ gtk3 accountsservice gnome3.libgee wayland wayland-protocols json-glib ];
  
  buildPhase = ''
  	# Generate wayland bindings
	mkdir gen
	for file in `ls $src/protos/*.xml`; do
		wayland-scanner code $file "./gen/`basename $file .xml`-protocol.c"
		wayland-scanner client-header $file "./gen/`basename $file .xml`-client-protocol.h"
	done
  
  	# Compile the various executables
  	valac -o shell --vapidir $src/vapi --pkg gtk+-3.0 --pkg gio-unix-2.0 --pkg json-glib-1.0 $src/utils/*.vala $src/applets/*.vala $src/notify/*.vala $src/*.vala $src/*.c \
  		./gen/wayfire-shell-protocol.c -X -I./gen -X -Wl,-rpath,${pkgs.wayland}/lib/
  	
  	valac -o decorator --vapidir ${gnome3.libgee}/share/vala/vapi --pkg gtk+-3.0 --pkg gee-0.8 $src/decorator/*.vala $src/decorator/*.c \
  		./gen/wf-decorator-protocol.c -X -I./gen -X -Wl,-rpath,${pkgs.wayland}/lib/
  		
  	#valac -o notifications
  '';
  
  installPhase = ''
  	mkdir -p $out/bin/
  	mkdir -p $out/wayland-protocols
  	install $src/protos/wf-decorator.xml $out/wayland-protocols/
  	install -s ./shell $out/bin/shell
  	install -s ./decorator $out/bin/decorator
  	#install -s ./notifications $out/bin/notificationsS
  '';
}