{...}: let
  port = 19999;
  app-name = "netdata";
  display-name = "NetData";
  network = import ../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
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
  services.olivetin.settings.actions = [
    {
      title = "Restart ${display-name}";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /var/lib/olivetin/scripts/commands.sh -s ${app-name}";
      timeout = 20;
    }
  ];
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  services.netdata.config.registry.enabled = "yes";
}
