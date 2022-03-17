{ pkgs, ... }:

let
  inherit (pkgs) fetchurl;
  inherit (pkgs.stdenv) mkDerivation;
in mkDerivation rec {
  pname = "cook-cli";
  version = "0.1.4";
  cldrVersion = "v0.1.4";
  dontBuild = true;
  dontStrip = true;
  dontConfigure = true;
  src = fetchurl {
    url =
      "https://github.com/cooklang/CookCLI/releases/download/${cldrVersion}/CookCLI_${version}_linux_amd64.zip";
    sha256 = "0b4907ed811a03008043caee3622b70a221314f0305ca74597db8723730201c0";
  };
  unpackPhase = "unpackFile $src";
  installPhase = "install -m755 -D cook $out/bin/cook";
}
