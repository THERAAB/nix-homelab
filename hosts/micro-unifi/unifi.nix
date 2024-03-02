{...}: let
  gid = 7813;
  port = 8443;
  app-name = "unifi";
  local-config-dir = "/var/lib/${app-name}";
  network = import ../../share/network.properties.nix;
  users = import ../../share/users.properties.nix;
in {
  users = {
    users."${app-name}" = {
      uid = users.unifi.uid;
      group = app-name;
      isSystemUser = true;
    };
    groups.${app-name}.gid = gid;
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}     -       -             -           -   - "
    "d    ${local-config-dir}/db  -       -             -           -   - "
    "Z    ${local-config-dir}     -       ${app-name}   ${app-name} -   - "
  ];
  virtualisation.oci-containers.containers = {
    "${app-name}" = {
      autoStart = true;
      image = "lscr.io/linuxserver/unifi-network-application";
      volumes = [
        "${local-config-dir}:/config"
      ];
      ports = [
        "${toString port}:8443"
        "3478:3478/udp"
        "1001:1001/udp"
        "8080:8080"
      ];
      environment = {
        PUID = "${toString users.unifi.uid}";
        PGID = "${toString gid}";
        UMASK = "022";
        TZ = "America/New_York";
        MONGO_HOST = "${network.micro-unifi.local.ip}";
        MONGO_PORT = "27017";
      };
      environmentFiles = [
        "/run/secrets/mongo_secret"
      ];
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ];
    };
    "unifi-db" = {
      autoStart = true;
      image = "docker.io/mongo:6.0";
      volumes = [
        "${local-config-dir}/db:/data/db"
        "/run/secrets/mongo_init:/docker-entrypoint-initdb.d/init-mongo.js:ro"
      ];
      user = "${toString users.unifi.uid}";
      environment = {
        PUID = "${toString users.unifi.uid}";
        PGID = "${toString gid}";
        UMASK = "022";
        TZ = "America/New_York";
      };
      ports = [
        "27017:27017"
      ];
      extraOptions = [
        "-l=io.containers.autoupdate=registry"
      ];
    };
  };
}
