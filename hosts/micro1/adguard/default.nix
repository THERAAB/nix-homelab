{...}: let
  port = 3000;
  settings = (import ./settings.nix).settings;
  app-name = "adguard";
  display-name = "Adguard";
  network = import ../../../../share/network.properties.nix;
in {
  services = {
    yamlConfigMaker.gatus.settings.endpoints = [
      {
        name = "${display-name}";
        url = "https://${app-name}.${network.domain}/";
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<title>Login</title>*)''
        ];
        alerts = [
          {
            type = "gotify";
          }
        ];
      }
    ];
    caddy.virtualHosts."${app-name}.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy ${network.micro1.local.ip}:${toString port}
      '';
    };
    adguardhome = {
      mutableSettings = false;
      enable = true;
      settings = settings;
    };
  };
  networking.firewall.allowedTCPPorts = [port];
}
