{
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "OliveTin";
  version = "2023.10.25";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${version}/OliveTin-linux-amd64.tar.gz";
    sha256 = "sha256-kIlZlBIdv8eSImP2pG+1ox/H9k+2rWqmlQnzuG1T31M=";
  };
  installPhase = ''
    install -m755 -D ./OliveTin $out/bin/olivetin
    mkdir -p $out/www
    cp -r webui/* $out/www/
  '';
}
