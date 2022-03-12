{ pkgs, ... }:

with pkgs; stdenv.mkDerivation {
  pname = "swaylock-blur";
  version = "0.1";
  buildInputs = [ swaylock grim imagemagick ];
  src = ./.;
  dontBuild = true;
  dontStrip = true;
  dontConfigure = true;
  postPatch = ''
    substituteInPlace swaylock-blur.sh \
      --replace "swaylock" "${swaylock}/bin/swaylock" \
      --replace "grim" "${grim}/bin/grim" \
      --replace "convert" "${imagemagick}/bin/convert"
  '';
  installPhase = ''
    install -m755 -D swaylock-blur.sh $out/bin/swaylock-blur
  '';
}