{
  fetchFromGitHub,
  buildHomeAssistantComponent,
  plugp100,
}:
buildHomeAssistantComponent rec {
  domain = "home-assistant-tapo-p100";
  owner = "petretiandrea";
  version = "v2.10.0";
  src = fetchFromGitHub {
    repo = "home-assistant-tapo-p100";
    rev = version;
    owner = "petretiandrea";
    sha256 = "sha256-vpF9QFu3LA/XFtDM0ZdmZq6FFsZvCCOJ10alLf+iWVA=";
  };
  propagatedBuildInputs = [
    plugp100
  ];
}
