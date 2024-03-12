{...}: let
  gid = 7763;
  port = 9092;
  app-name = "flatnotes";
  local-config-dir = "/var/lib/${app-name}";
  users = import ../../../../../assets/properties/users.properties.nix;
in {
  users = {
    users."${app-name}" = {
      uid = users.flatnotes.uid;
      group = app-name;
      isSystemUser = true;
    };
    groups.${app-name}.gid = gid;
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}     -       -             -   -   - "
    "Z    ${local-config-dir}     -       ${app-name}   -   -   - "
  ];
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "docker.io/dullage/${app-name}";
    volumes = [
      "${local-config-dir}:/data"
    ];
    ports = [
      "${toString port}:8080"
    ];
    environment = {
      PUID = "${toString users.flatnotes.uid}";
      PGID = "${toString gid}";
      UMASK = "022";
      TZ = "America/New_York";
      FLATNOTES_AUTH_TYPE = "none";
    };
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
