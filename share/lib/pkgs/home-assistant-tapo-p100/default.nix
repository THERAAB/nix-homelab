{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "home-assistant-tapo-p100";
  version = "v2.10.0";
  src = fetchFromGitHub {
    inherit pname version;
    repo = pname;
    rev = version;
    owner = "petretiandrea";
    sha256 = "";
  };
  installPhase = ''
    mkdir -p $out/custom_components
    cp -r ./custom_components/tapo $out/custom_components/tapo
  '';
}
