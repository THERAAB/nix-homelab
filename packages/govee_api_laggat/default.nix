{
  python313Packages,
  fetchPypi,
  nix-homelab,
}:
python313Packages.buildPythonPackage rec {
  pname = "govee_api_laggat";
  version = "0.2.2";
  pyproject = true;
  src = fetchPypi {
    inherit version pname;
    hash = "sha256-6nZzc3zY9UXGFK7r1SeOMzEzIwakW5anbu7lJwWqwI4=";
  };
  propagatedBuildInputs = with python313Packages; [
    nix-homelab.bios
    pexpect
    events
    pygatt
    aiohttp
    certifi
    dacite
    pytest
  ];
}
