{
  fetchFromGitHub,
  buildHomeAssistantComponent,
  python314Packages,
}:
buildHomeAssistantComponent rec {
  domain = "tapo";
  owner = "petretiandrea";
  version = "3.2.2";
  src = fetchFromGitHub {
    repo = "home-assistant-tapo-p100";
    rev = version;
    owner = "petretiandrea";
    sha256 = "sha256-tvLuj8CEY4yhsdF48Ftzy1hGyJ2E9cxmc6feuHv0rgg=";
  };
  propagatedBuildInputs = [
    python314Packages.plugp100
  ];
}
