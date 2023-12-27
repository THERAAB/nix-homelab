{
  fetchFromGitHub,
  buildHomeAssistantComponent,
  plugp100,
}:
buildHomeAssistantComponent {
  version = "v2.10.0";
  owner = "petretiandrea";
  domain = "tapo";

  src = fetchFromGitHub {
    owner = "petretiandrea";
    repo = "home-assistant-tapo-p100";
    rev = "v2.10.0";
    sha256 = "sha256-vpF9QFu3LA/XFtDM0ZdmZq6FFsZvCCOJ10alLf+iWVA=";
  };

  dontBuild = true;

  propogatedBuildInputs = [
    plugp100
  ];

  doCheck = false;
}
