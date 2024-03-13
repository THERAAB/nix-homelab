{properties, ...}: let
  uid = 9996;
  port = properties.ports.audiobookshelf;
  app-name = "audiobookshelf";
  local-config-dir = "/var/lib/${app-name}";
in {
  users = {
    users."${app-name}" = {
      uid = uid;
      group = properties.media.group.name;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}           -       -             -                               -   - "
    "d    ${local-config-dir}/config    -       -             -                               -   - "
    "d    ${local-config-dir}/metadata  -       -             -                               -   - "
    "Z    ${local-config-dir}           -       ${app-name}   ${properties.media.group.name}  -   - "
  ];
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "ghcr.io/advplyr/${app-name}:latest";
    volumes = [
      "${local-config-dir}/config:/config"
      "${local-config-dir}/metadata:/metadata"
      "${properties.media.dir.audiobooks}:/audiobooks"
      "${properties.media.dir.podcasts}:/podcasts"
    ];
    ports = ["${toString port}:80"];
    environment = {
      AUDIOBOOKSHELF_UID = "${toString uid}";
      AUDIOBOOKSHELF_GID = "${toString properties.media.group.id}";
      UMASK = "022";
      TZ = "America/New_York";
    };
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
