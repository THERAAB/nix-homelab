{...}: let
  port = 19999;
  app-name = "netdata";
  network = import ../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "NetData";
      url = "https://${app-name}.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>netdata dashboard</title>*)''
      ];
      alerts = [
        {
          type = "custom";
        }
      ];
    }
  ];
  services.olivetin.settings.actions = [
    {
      title = "Restart NetData";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -s ${app-name}";
      timeout = 20;
    }
  ];
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  networking.firewall.allowedTCPPorts = [port];
  services.netdata = {
    enable = true;
    configText = ''
      [global]
        update every = 5
      [ml]
        enabled = no
      [logs]
        debug log = none
        error log = none
        access log = none
    '';
  };
}
