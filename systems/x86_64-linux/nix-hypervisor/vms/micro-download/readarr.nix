{
  media,
  ports,
  ...
}: let
  uid = 9997;
  port = ports.readarr;
  app-name = "readarr";
  local-config-dir = "/var/lib/${app-name}/";
in {
  users = {
    users."${app-name}" = {
      uid = uid;
      group = media.group.name;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}     -       -             -           -   - "
    "Z    ${local-config-dir}     -       ${app-name}   ${media.group.name} -   - "
  ];
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "lscr.io/linuxserver/${app-name}:develop";
    volumes = [
      "${local-config-dir}:/config"
      "${media.dir.audiobooks}:/books"
      "${media.dir.downloads}:/app/qBittorrent/downloads"
    ];
    ports = ["${toString port}:8787"];
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
