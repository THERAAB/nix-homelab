{
  python314Packages,
  fetchPypi,
}:
python314Packages.buildPythonPackage rec {
  pname = "securelogging";
  version = "1.0.1";
  pyproject = true;
  src = fetchPypi {
    inherit version pname;
    hash = "sha256-nd1/nTh1NuKhlkjI5o3pc7lb/vgo48CoJMUQcQMT/cc=";
  };
  build-system = [ python314Packages.hatchling ];
}
