{ config, pkgs, ... }:
let
  port = 2342;
  app-name = "photoprism";
  network = import ../../../share/network.properties.nix;
  local-config-dir = "/nix/persist/${app-name}";
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
  systemd.tmpfiles.rules = [
    "Z  ${local-config-dir}         740     ${app-name}    ${app-name}    -   - "
    "Z  ${local-config-dir}/photos  740     ${app-name}    ${app-name}    -   - "
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
  services.${app-name} = {
    enable = true;
    originalsPath = "/photos";
  };

}
