{
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "OliveTin";
  version = "2023.03.25";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${version}/OliveTin-linux-amd64.tar.gz";
    sha256 = "sha256-s+6Em0r03dicTO4BrgfuaJYog2+USJlvFOGnAw9bD3E=";
  };
  installPhase = ''
    install -m755 -D ./OliveTin $out/bin/olivetin
    mkdir -p $out/www
    cp -r webui/* $out/www/
  '';
}
