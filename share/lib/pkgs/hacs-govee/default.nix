{ stdenv, fetchFromGitHub }:

  stdenv.mkDerivation rec {
    pname = "hacs-govee";
    version = "0.2.2";
    src = fetchFromGitHub {
      inherit pname version;
      repo = pname;
      rev = version;
      owner  = "LaggAt";
      sha256 = "#sha256-vIBx+t+AcWG9z7O5bv4yMMCplpc54N29/QxMUwHjeSU=";
    };
    installPhase = ''
      mkdir -p $out/custom_components
      cp -r ./custom_components/govee $out/custom_components/govee
      echo hello
    '';
  }