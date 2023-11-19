{...}: let
  port = 3000;
  settings = (import ./settings.nix).settings;
  app-name = "adguard";
  network = import ../../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Adguard";
      url = "https://${app-name}.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>Login</title>*)''
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
      title = "Restart AdGuard";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /var/lib/olivetin/scripts/commands.sh -s adguardhome";
      timeout = 20;
    }
  ];
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      # Enable Authelia
      forward_auth 127.0.0.1:9091 {
        uri /api/verify?rd=https://auth.pumpkin.rodeo/
        copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
      }
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  networking.firewall.allowedTCPPorts = [port];
  services.adguardhome = {
    mutableSettings = false;
    enable = true;
    settings = settings;
  };
}
