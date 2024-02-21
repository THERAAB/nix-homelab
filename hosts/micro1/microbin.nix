{...}: let
  port = 9080;
  app-name = "microbin";
  display-name = "Microbin";
  network = import ../../../share/network.properties.nix;
in {
  networking.firewall.allowedTCPPorts = [port];
  services = {
    yamlConfigMaker.gatus.settings.endpoints = [
      {
        name = "${display-name}";
        url = "https://${app-name}.${network.domain}";
        conditions = [
          "[STATUS] == 200"
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
    microbin = {
      enable = true;
      passwordFile = "/run/secrets/df_password";
      settings = {
        MICROBIN_PORT = port;
      };
    };
  };
}
