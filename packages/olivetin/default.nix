{
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  # TODO: remove
  pname = "OliveTin";
  version = "2024.11.24";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${version}/OliveTin-linux-amd64.tar.gz";
    sha256 = "sha256-g7T0YIyQeByhoDvCSTnuuKVpAc/4eixaNPWcCI8AgXg=";
  };
  installPhase = ''
    install -m755 -D ./OliveTin $out/bin/olivetin
    mkdir -p $out/www
    cp -r webui/* $out/www/
  '';
}
