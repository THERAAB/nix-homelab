
{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "tuya-smart-life";
  version = "fae5fd7d602f86dd95eeaa4144b89bfaeb5d0adc";
  src = fetchFromGitHub {
    inherit pname version;
    repo = pname;
    rev = version;
    owner = "tuya";
    sha256 = "";
  };
  installPhase = ''
    mkdir -p $out/custom_components
    cp -r ./custom_components/smartlife $out/custom_components/smartlife
  '';
}