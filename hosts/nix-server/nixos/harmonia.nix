{config, ...}: let
  network = import ../../../share/network.properties.nix;
  port = 5000;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Harmonia Cache";
      url = "https://cache.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>*harmonia*</title>*)''
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
  ];
  services.harmonia = {
    enable = true;
    signKeyPath = config.sops.secrets.harmonia-key.path;
  };
  nix.settings.allowed-users = ["harmonia"];
  services.caddy.virtualHosts."cache.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
