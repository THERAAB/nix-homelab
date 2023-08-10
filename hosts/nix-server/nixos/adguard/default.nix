{...}: let
  port = 3000;
  settings = (import ./settings.nix).settings;
  app-name = "adguard";
  network = import ../../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Adguard";
      url = "http://${app-name}.${network.domain.local}/";
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
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -s adguardhome";
      timeout = 20;
    }
  ];
  services.caddy.virtualHosts = {
    "http://adguard.${network.domain.box}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://adguard.${network.domain.local}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  networking.firewall.allowedTCPPorts = [port];
  services.adguardhome = {
    mutableSettings = false;
    enable = true;
    settings = settings;
  };
}
