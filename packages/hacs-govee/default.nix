{
  fetchFromGitHub,
  buildHomeAssistantComponent,
  nix-homelab,
}:
buildHomeAssistantComponent rec {
  domain = "govee";
  owner = "LaggAt";
  version = "0.2.2";
  src = fetchFromGitHub {
    repo = "hacs-govee";
    rev = version;
    owner = "LaggAt";
    sha256 = "sha256-vIBx+t+AcWG9z7O5bv4yMMCplpc54N29/QxMUwHjeSU=";
  };
  propagatedBuildInputs = [
    nix-homelab.govee_api_laggat
  ];
  ignoreVersionRequirement = [
    "dacite"
  ];
}
