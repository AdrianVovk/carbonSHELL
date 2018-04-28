with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "libweston-custom-${version}";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner  = "ammen99";
    repo   = "weston";
    rev    = "01bb8ddb2439e61743d3e579e1d354a84f705e44";
    sha256 = "0gf10hd7bmw542i2r3vp9nniqy25671p47jz31dqzv7h1dizyd97";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig autoconf automake libtool autoconf-archive  ];
  propagatedBuildInputs = [  
    wayland libGLU_combined libxkbcommon cairo xorg.libxcb xorg.libXcursor xlibsWrapper udev libdrm
    mtdev libjpeg pam dbus libinput pango libunwind freerdp libva
    libwebp wayland-protocols
  ];

  configureScript = "./autogen.sh";
  configureFlags = [
    "--enable-x11-compositor"
    "--enable-drm-compositor"
    "--enable-wayland-compositor"
    "--enable-headless-compositor"
    "--enable-fbdev-compositor"
    "--enable-screen-sharing"
    "--enable-clients"
    "--enable-weston-launch"
    "--disable-setuid-install"
  ];
}
