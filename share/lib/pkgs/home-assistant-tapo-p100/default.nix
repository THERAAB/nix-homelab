{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "home-assistant-tapo-p100";
  version = "v2.7.0";
  src = fetchFromGitHub {
    inherit pname version;
    repo = pname;
    rev = version;
    owner = "petretiandrea";
    sha256 = "sha256-rVFUZTWtS6fUb9I1iMex1WHYbSfI06/xWj/qoiL3EDs=";
  };
  installPhase = ''
    mkdir -p $out/custom_components
    cp -r ./custom_components/tapo $out/custom_components/tapo
  '';
}
