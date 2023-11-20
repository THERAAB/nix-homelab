
{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "localtuya";
  version = "v5.2.1";
  src = fetchFromGitHub {
    inherit pname version;
    repo = pname;
    rev = version;
    owner = "rospogrigio";
    sha256 = "";
  };
  installPhase = ''
    mkdir -p $out/custom_components
    cp -r ./custom_components/localtuya $out/custom_components/localtuya
  '';
}