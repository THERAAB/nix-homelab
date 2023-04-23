{ config, pkgs, ... }:
let
  port = 2342;
  uid=9116;
  app-name = "photoprism";
  network = import ../../../share/network.properties.nix;
in
{
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Photoprism";
      url = "http://${app-name}.${network.domain.local}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>PhotoPrism</title>*)''
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
      title = "Restart PhotoPrism";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -s ${app-name}";
      timeout = 20;
    }
  ];
  services.caddy.virtualHosts = {
    "http://${app-name}.${network.domain.local}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.${network.domain.tail}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  networking.firewall.allowedTCPPorts = [ port ];
  users = {
    users."${app-name}" = {
      group = app-name;
      uid = uid;
      isSystemUser = true;
    };
  };
  services.${app-name} = {
    enable = true;
    address = "0.0.0.0";
    originalsPath = "/var/lib/private/photoprism/originals";
    passwordFile = config.sops.secrets.df_password.path;
  };
}
