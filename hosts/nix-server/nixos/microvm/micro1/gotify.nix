{...}: let
  port = 8238;
  app-name = "gotify";
  display-name = "Gotify";
  network = import ../../../../../share/network.properties.nix;
  local-config-dir = "/var/lib/private/gotify-server";
in {
  microvm.shares = [
    {
      proto = "virtiofs";
      source = local-config-dir;
      mountPoint = local-config-dir;
      tag = app-name;
    }
  ];
  services = {
    yamlConfigMaker.gatus.settings.endpoints = [
      {
        name = "${display-name}";
        url = "https://${app-name}.${network.domain}/";
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
    ${app-name} = {
      enable = true;
      port = port;
    };
  };
}
