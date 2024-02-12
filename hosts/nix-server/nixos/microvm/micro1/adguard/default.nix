{...}: let
  port = 3000;
  settings = (import ./settings.nix).settings;
  app-name = "adguard";
  display-name = "Adguard";
  network = import ../../../../../../share/network.properties.nix;
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
    olivetin.settings.actions = [
      {
        title = "Restart ${display-name}";
        icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
        shell = "sudo /var/lib/olivetin/scripts/commands.sh -s adguardhome";
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
    adguardhome = {
      mutableSettings = false;
      enable = true;
      settings = settings;
    };
  };
  networking.firewall.allowedTCPPorts = [port];
}
