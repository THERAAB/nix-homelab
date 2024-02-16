{...}: let
  port = 9080;
  app-name = "microbin";
  display-name = "Microbin";
  network = import ../../../../../share/network.properties.nix;
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
    olivetin.settings.actions = [
      {
        title = "Restart ${display-name}";
        icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
        shell = "sudo /var/lib/olivetin/scripts/commands.sh -s ${app-name}";
        timeout = 20;
      }
    ];
    caddy.virtualHosts."${app-name}.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString port}
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
