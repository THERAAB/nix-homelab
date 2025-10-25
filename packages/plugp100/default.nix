{
  python313Packages,
  fetchPypi,
}:
python313Packages.buildPythonPackage rec {
  pname = "plugp100";
  version = "3.12.0";
  pyproject = true;
  src = fetchPypi {
    inherit version pname;
    hash = "sha256-jfitt8qCq8nRbCgv81qz3Wtwp0R9fXQ7TjP88Sh2oIY=";
  };
  propagatedBuildInputs = with python313Packages; [
    certifi
    cryptography
    jsons
    requests
    aiohttp
    semantic-version
    scapy
  ];
}
