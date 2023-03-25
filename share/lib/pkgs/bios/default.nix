{ lib, buildPythonPackage, fetchPypi, oyaml, pyyaml }:

  buildPythonPackage rec {
    pname = "bios";
    version = "0.1.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-vM/CQBG2pjGm7e7xBpVRpOyq/3s+1QpiIaaAdYUFAOk=";
    };

    doCheck = false;

    propagatedBuildInputs = [
      oyaml pyyaml
    ];

    meta = with lib; {
      description = '''bios' is a python library which helps you for operations of I/O.
      You can read determined type of files and assign the content of the files to the best suitable data type for these contents.
      If it is required, developer should handle the exception handling issues.'';
      homepage = "https://github.com/bilgehannal/bios";
      license = licenses.mit;
      maintainers = with maintainers; [ bilgehannal ];
    };

  }