{ config, pkgs, ... }:
let
  port = 3000;
  settings = import ./settings.nix;
in
{
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Adguard";
      url = "http://adguard.server.box/";
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
      icon = ''<img src = "customIcons/adguard.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -s adguardhome";
      timeout = 20;
    }
  ];
  services.caddy.virtualHosts = {
    "http://adguard.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://adguard.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  networking.firewall.allowedTCPPorts = [ port ];
  services.adguardhome = {
    mutableSettings = false;
    enable = true;
    settings = settings;
  };
}