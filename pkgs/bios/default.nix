{ stdenv, fetchFromGitHub }:

  stdenv.mkDerivation rec {
    pname = "bios";
    version = "0.1.2";
    src = buildPythonPackage {
      inherit pname version;
      src = fetchPypi {
        inherit pname version;
        hash = "sha256-vM/CQBG2pjGm7e7xBpVRpOyq/3s+1QpiIaaAdYUFAOk=";
      };
      propagatedBuildInputs = [
        oyaml pyyaml
      ];
    };
  }