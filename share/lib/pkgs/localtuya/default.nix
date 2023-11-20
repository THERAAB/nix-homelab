
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
    sha256 = "sha256-hA/1FxH0wfM0jz9VqGCT95rXlrWjxV5oIkSiBf0G0ac=";
  };
  installPhase = ''
    mkdir -p $out/custom_components
    cp -r ./custom_components/localtuya $out/custom_components/localtuya
  '';
}