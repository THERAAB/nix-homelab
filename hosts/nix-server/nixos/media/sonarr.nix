{ config, pkgs, ... }:
let
  media = import ./media.properties.nix;
  uid = 9995;
  port = 8989;
  app-name = "sonarr";
  local-config-dir = media.dir.config + "/${app-name}/";
  network = import ../../../../share/network.properties.nix;
in
{
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Sonarr";
      url = "http://${app-name}.${network.domain.local}/health";
      conditions = [
        "[STATUS] == 200"
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
      title = "Restart Sonarr";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p ${app-name}";
      timeout = 20;
    }
  ];
  users = {
    users."${app-name}" = {
      group = "media";
      uid = uid;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}     -       -             -        -   - "
    "Z    ${local-config-dir}     740     ${app-name}   media    -   - "
  ];
  services.caddy.virtualHosts = {
    "http://${app-name}.${network.domain.local}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.${network.domain.tail}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "linuxserver/${app-name}";
    volumes = [
      "${local-config-dir}:/config"
      "${media.dir.tv}:/tv"
      "${media.dir.downloads}:/app/qBittorrent/downloads"
    ];
    ports = [ "${toString port}:${toString port}" ];
    environment = {
      PUID="${toString uid}";
      PGID="${toString media.gid}";
      UMASK="022";
      TZ="America/New_York";
    };
  };
}