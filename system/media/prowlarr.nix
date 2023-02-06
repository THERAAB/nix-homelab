{ config, pkgs, ... }:
let
  media = (import ./media.properties.nix);
  uid = 9993;
  port = 9696;
  app-name = "prowlarr";
  local-config-dir = media.dir.config + "/${app-name}/";
in
{
#  imports = [
#    ../../modules/nixos/olivetin
#    ../../modules/nixos/yamlConfigMaker
#  ];

  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Prowlarr";
      url = "http://prowlarr.server.box/health";
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
      title = "Restart Prowlarr";
      icon = ''<img src = "customIcons/prowlarr.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p prowlarr";
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
    "http://${app-name}.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "linuxserver/${app-name}:develop";
    volumes = [
      "${local-config-dir}:/config"
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