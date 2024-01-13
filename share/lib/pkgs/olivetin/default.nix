{
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "OliveTin";
  version = "2023.12.1";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${version}/OliveTin-linux-amd64.tar.gz";
    sha256 = "sha256-paCzQu6599kTvefj/2tB7bG0hjwMYffGgCRhGQvcvsA=";
  };
  installPhase = ''
    install -m755 -D ./OliveTin $out/bin/olivetin
    mkdir -p $out/www
    cp -r webui/* $out/www/
  '';
}
