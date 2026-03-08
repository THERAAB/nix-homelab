{
  fetchFromGitHub,
  buildHomeAssistantComponent,
  python313Packages,
  nix-homelab
}:
buildHomeAssistantComponent rec {
  domain = "hubspace";
  owner = "jdeath";
  version = "v5.10.0";
  src = fetchFromGitHub {
    repo = "Hubspace-Homeassistant";
    rev = version;
    owner = "jdeath";
    sha256 = "sha256-+k9nVJH7IA8Bk5a7ADTTwQ6H140zPaby/tvJdaxQh1E=";
  };
  propagatedBuildInputs = [
    python313Packages.aiofiles
    nix-homelab.aioafero
  ];
}
