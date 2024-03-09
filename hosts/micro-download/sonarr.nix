{...}: let
  media = import ../../share/media.properties.nix;
  uid = 9995;
  port = 8989;
  app-name = "sonarr";
  local-config-dir = "/var/lib/${app-name}";
in {
  users = {
    users."${app-name}" = {
      uid = uid;
      group = media.group.name;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}     -       -             -                   -   - "
    "Z    ${local-config-dir}     -       ${app-name}   ${media.group.name} -   - "
  ];
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "lscr.io/linuxserver/${app-name}";
    volumes = [
      "${local-config-dir}:/config"
      "${media.dir.tv}:/tv"
      "${media.dir.downloads}:/app/qBittorrent/downloads"
    ];
    ports = ["${toString port}:8989"];
    environment = {
      PUID = "${toString uid}";
      PGID = "${toString media.group.id}";
      UMASK = "022";
      TZ = "America/New_York";
    };
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
