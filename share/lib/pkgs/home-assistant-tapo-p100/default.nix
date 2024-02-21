{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "home-assistant-tapo-p100";
  version = "v2.13.0";
  src = fetchFromGitHub {
    inherit pname version;
    repo = pname;
    rev = version;
    owner = "petretiandrea";
    sha256 = "sha256-RCZte/US7LWYUmv8GZKBDK7qcfmitQCdDrdr1BxKZ/g=";
  };
  installPhase = ''
    mkdir -p $out/custom_components
    cp -r ./custom_components/tapo $out/custom_components/tapo
  '';
}
