{
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "OliveTin";
  version = "2024.03.081";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${version}/OliveTin-linux-amd64.tar.gz";
    sha256 = "sha256-jqqcRSAgpyiZtuTs0JPVARqx4Cp4xUNozzjAXu/mtEg=";
  };
  installPhase = ''
    install -m755 -D ./OliveTin $out/bin/olivetin
    mkdir -p $out/www
    cp -r webui/* $out/www/
  '';
}
