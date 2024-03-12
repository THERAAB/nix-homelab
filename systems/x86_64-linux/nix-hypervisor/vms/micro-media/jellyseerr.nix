{...}: let
  media = import ../../../../../assets/properties/media.properties.nix;
  uid = 9991;
  port = 5055;
  app-name = "jellyseerr";
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
    "d    ${local-config-dir}     -       -           -                     -   - "
    "Z    ${local-config-dir}     -       ${app-name} ${media.group.name}   -   - "
  ];
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "docker.io/fallenbagel/${app-name}";
    volumes = [
      "${local-config-dir}:/app/config"
      "${media.dir.movies}:/movies"
      "${media.dir.tv}:/tv"
    ];
    ports = ["${toString port}:5055"];
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
