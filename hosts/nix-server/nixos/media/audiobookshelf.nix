{...}: let
  media = import ./media.properties.nix;
  uid = 9996;
  gid = 9112;
  port = 13379;
  app-name = "audiobookshelf";
  display-name = "Audiobookshelf";
  local-config-dir = "/var/lib/${app-name}";
  network = import ../../../../share/network.properties.nix;
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
      shell = "sudo /var/lib/olivetin/scripts/commands.sh -s podman-${app-name}";
      timeout = 20;
    }
  ];
  users = {
    users."${app-name}" = {
      uid = uid;
      group = app-name;
      isSystemUser = true;
    };
    groups.${app-name}.gid = gid;
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}           -       -             -           -   - "
    "d    ${local-config-dir}/config    -       -             -           -   - "
    "d    ${local-config-dir}/metadata  -       -             -           -   - "
    "Z    ${local-config-dir}           740     ${app-name}   ${app-name} -   - "
  ];
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "ghcr.io/advplyr/${app-name}:latest";
    volumes = [
      "${local-config-dir}/config:/config"
      "${local-config-dir}/metadata:/metadata"
      "${media.dir.audiobooks}:/audiobooks"
      "${media.dir.podcasts}:/podcasts"
    ];
    ports = ["${toString port}:80"];
    environment = {
      AUDIOBOOKSHELF_UID = "${toString uid}";
      AUDIOBOOKSHELF_GID = "${toString gid}";
      UMASK = "022";
      TZ = "America/New_York";
    };
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
