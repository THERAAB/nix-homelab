{
  python312Packages,
  fetchPypi,
  nix-homelab,
}:
python312Packages.buildPythonPackage rec {
  pname = "govee_api_laggat";
  version = "0.2.2";
  src = fetchPypi {
    inherit version pname;
    hash = "sha256-6nZzc3zY9UXGFK7r1SeOMzEzIwakW5anbu7lJwWqwI4=";
  };
  nativeBuildInputs = with python312Packages; [
    pythonRelaxDepsHook
    dacite
  ];
  propagatedBuildInputs = with python312Packages; [
    nix-homelab.bios
    pexpect
    events
    pygatt
    aiohttp
    certifi
    dacite
    pytest
  ];
  strictDeps = false;
  pythonRelaxDeps = [
    "dacite"
  ];
}
