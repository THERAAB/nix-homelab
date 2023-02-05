{ lib, buildPythonPackage, fetchPypi, oyaml, pyyaml }:

  buildPythonPackage (rec {
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
      homepage = "http://www.noah.org/wiki/Pexpect";
      description = "Automate interactive console applications such as ssh, ftp, etc";
      license = licenses.mit;
      maintainers = with maintainers; [ zimbatm ];

      longDescription = ''
        Pexpect is similar to the Don Libes "Expect" system, but Pexpect
        as a different interface that is easier to understand. Pexpect
        is basically a pattern matching system. It runs programs and
        watches output. When output matches a given pattern Pexpect can
        respond as if a human were typing responses. Pexpect can be used
        for automation, testing, and screen scraping. Pexpect can be
        used for automating interactive console applications such as
        ssh, ftp, passwd, telnet, etc. It can also be used to control
        web applications via "lynx", "w3m", or some other text-based web
        browser. Pexpect is pure Python. Unlike other Expect-like
        modules for Python Pexpect does not require TCL or Expect nor
        does it require C extensions to be compiled. It should work on
        any platform that supports the standard Python pty module.
      '';
    };

  })