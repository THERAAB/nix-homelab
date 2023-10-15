{...}: let
  media = import ./media.properties.nix;
  uid = 9996;
  port = 13378;
  app-name = "audiobookshelf";
  local-config-dir = media.dir.config + "/${app-name}";
  network = import ../../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Audiobookshelf";
      url = "http://${app-name}.${network.domain.local}/";
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
      title = "Restart Audiobookshelf";
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
    "d    ${local-config-dir}           -       -             -        -   - "
    "d    ${local-config-dir}/config    -       -             -        -   - "
    "d    ${local-config-dir}/metadata  -       -             -        -   - "
    "Z    ${local-config-dir}           740     ${app-name}   media    -   - "
  ];
  services.caddy.virtualHosts = {
    "http://${app-name}.${network.domain.local}".extraConfig = ''
      encode gzip zstd
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "advplyr/${app-name}";
    volumes = [
      "${local-config-dir}/config:/config"
      "${local-config-dir}/metadata:/metadata"
      "${media.dir.audiobooks}:/audiobooks"
    ];
    ports = ["${toString port}:${toString port}"];
    environment = {
      PUID = "${toString uid}";
      PGID = "${toString media.gid}";
      UMASK = "022";
      TZ = "America/New_York";
    };
  };
}
