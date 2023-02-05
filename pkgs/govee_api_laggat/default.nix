{ lib, buildPythonPackage, fetchPypi, bios, pexpect, events, pygatt, certifi, dacite, pytest, aiohttp }:

  buildPythonPackage rec {
    pname = "govee_api_laggat";
    version = "0.2.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-6nZzc3zY9UXGFK7r1SeOMzEzIwakW5anbu7lJwWqwI4=";
    };

    doCheck = false;

    propagatedBuildInputs = [
      bios
      pexpect
      events
      pygatt
      python.pkgs.my_stuff.aiohttp
      certifi
      dacite
      pytest
    ];
  }