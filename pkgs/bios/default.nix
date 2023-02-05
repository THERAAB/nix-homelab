{ lib, buildPythonPackage, fetchPypi, oyaml, pyyaml }:

  buildPythonPackage {
    pname = "bios";
    version = "0.1.2";
    src = fetchPypi {
      inherit pname;
      version = "0.1.2";
      sha256 = "sha256-vM/CQBG2pjGm7e7xBpVRpOyq/3s+1QpiIaaAdYUFAOk=";
    };

    doCheck = false;

    propagatedBuildInputs = [
      oyaml pyyaml
    ];

  }