{...}: let
  uid = 7812;
  gid = 7813;
  port = 8443;
  app-name = "unifi";
  local-config-dir = "/nix/persist/${app-name}/";
  network = import ../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Unifi Network Application";
      url = "https://${app-name}.${network.domain}:${toString port}";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "custom";
        }
      ];
      client.insecure = true;
    }
  ];
  services.olivetin.settings.actions = [
    {
      title = "Restart Unifi Network Application";
      icon = ''<img src = "customIcons/unifi.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p ${app-name}";
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
    "d    ${local-config-dir}     -       -             -        -   - "
    "d    ${local-config-dir}/db  -       -             -        -   - "
    "Z    ${local-config-dir}     740     ${app-name}   -        -   - "
  ];
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port} {
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';
  };
  virtualisation.oci-containers.containers."unifi-network-application" = {
    autoStart = true;
    image = "lscr.io/linuxserver/unifi-network-application";
    volumes = [
      "${local-config-dir}:/config"
    ];
    ports = [
      "${toString port}:${toString port}"
      "3478:3478/udp"
      "1001:1001/udp"
      "8080:8080"
    ];
    environment = {
      PUID = "${toString uid}";
      PGID = "${toString gid}";
      UMASK = "022";
      TZ = "America/New_York";
      MONGO_HOST = "${network.nix-server.local.ip}";
      MONGO_PORT = "27017";
    };
    environmentFiles = [
      "${local-config-dir}/env.secret"
    ];
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
  virtualisation.oci-containers.containers."unifi-db" = {
    autoStart = true;
    image = "docker.io/mongo:4.4";
    volumes = [
      "${local-config-dir}/db:/data/db"
      "${local-config-dir}/init-mongo.js:/docker-entrypoint-initdb.d/init-mongo.js:ro"
    ];
    user = "${toString uid}";
    ports = [
      "27017:27017" #TODO: use docker network instead of exposing this port
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