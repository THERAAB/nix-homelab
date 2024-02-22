{...}: let
  uid = 7662;
  gid = 7663;
  port = 9090;
  app-name = "linkding";
  local-config-dir = "/var/lib/${app-name}";
in {
  users = {
    users."${app-name}" = {
      uid = uid;
      group = app-name;
      isSystemUser = true;
    };
    groups.${app-name}.gid = gid;
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}     -       -             -           -   - "
    "Z    ${local-config-dir}     -       ${app-name}   ${app-name} -   - "
  ];
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "docker.io/sissbruecker/${app-name}";
    volumes = [
      "${local-config-dir}:/etc/linkding/data"
    ];
    ports = [
      "${toString port}:9090"
    ];
    environment = {
      PUID = "${toString uid}";
      PGID = "${toString gid}";
      UMASK = "022";
      TZ = "America/New_York";
    };
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
