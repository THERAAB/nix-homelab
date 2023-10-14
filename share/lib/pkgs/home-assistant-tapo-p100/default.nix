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
    sha256 = "sha256-vpF9QFu3LA/XFtDM0ZdmZq6FFsZvCCOJ10alLf+iWVA=";
  };
  installPhase = ''
    mkdir -p $out/custom_components
    cp -r ./custom_components/tapo $out/custom_components/tapo
  '';
}
