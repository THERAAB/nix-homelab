{
  python313Packages,
  fetchPypi,
  nix-homelab,
}:
python313Packages.buildPythonPackage rec {
  pname = "aioafero";
  version = "6.0.1";
  pyproject = true;
  src = fetchPypi {
    inherit version pname;
    hash = "sha256-Gmbj5Ona4yKVsTblyodTbnP1FDwW2ui76+Qh8OiV56w=";
  };
  propagatedBuildInputs = with python313Packages; [
    aiohttp
    beautifulsoup4
    nix-homelab.securelogging
  ];
  build-system = [python313Packages.hatchling];
}
