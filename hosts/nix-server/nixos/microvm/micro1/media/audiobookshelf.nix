{...}: let
  media = import ./media.properties.nix;
  uid = 9996;
  port = 13379;
  app-name = "audiobookshelf";
  display-name = "Audiobookshelf";
  local-config-dir = "/var/lib/${app-name}";
  network = import ../../../../../../share/network.properties.nix;
in {
  services = {
    yamlConfigMaker.gatus.settings.endpoints = [
      {
        name = "${display-name}";
        url = "https://audiobooks.${network.domain}/";
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
    caddy.virtualHosts."audiobooks.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy ${network.micro1.local.ip}:${toString port}
      '';
    };
  };
  users = {
    users."${app-name}" = {
      uid = uid;
      group = media.group.name;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}           -       -             -                   -   - "
    "d    ${local-config-dir}/config    -       -             -                   -   - "
    "d    ${local-config-dir}/metadata  -       -             -                   -   - "
    "Z    ${local-config-dir}           -       ${app-name}   ${media.group.name} -   - "
  ];
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
      AUDIOBOOKSHELF_GID = "${toString media.group.id}";
      UMASK = "022";
      TZ = "America/New_York";
    };
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
