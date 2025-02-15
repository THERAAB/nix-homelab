{
  fetchFromGitHub,
  buildHomeAssistantComponent,
  nix-homelab,
}:
buildHomeAssistantComponent rec {
  domain = "tapo";
  owner = "petretiandrea";
  version = "v2.10.0";
  src = fetchFromGitHub {
    repo = "home-assistant-tapo-p100";
    rev = version;
    owner = "petretiandrea";
    sha256 = "sha256-vpF9QFu3LA/XFtDM0ZdmZq6FFsZvCCOJ10alLf+iWVA=";
  };
  propagatedBuildInputs = [
    nix-homelab.plugp100
  ];
}
