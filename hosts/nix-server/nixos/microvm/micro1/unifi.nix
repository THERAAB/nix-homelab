{config, ...}: let
  uid = 7812;
  gid = 7813;
  port = 8443;
  app-name = "unifi";
  display-name = "Unifi Network Application";
  local-config-dir = "/var/lib/${app-name}/";
  network = import ../../../../../share/network.properties.nix;
in {
  services = {
    yamlConfigMaker.gatus.settings.endpoints = [
      {
        name = "${display-name}";
        url = "https://${app-name}.${network.domain}:${toString port}";
        conditions = [
          "[STATUS] == 200"
        ];
        alerts = [
          {
            type = "gotify";
          }
        ];
        client.insecure = true;
      }
    ];
    olivetin.settings.actions = [
      {
        title = "Restart ${display-name}";
        icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
        shell = "sudo /var/lib/olivetin/scripts/commands.sh -s podman-${app-name}";
        timeout = 20;
      }
    ];
    caddy.virtualHosts."${app-name}.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString port} {
          transport http {
            tls_insecure_skip_verify
          }
        }
      '';
    };
  };
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
        PUID = "${toString uid}";
        PGID = "${toString gid}";
        UMASK = "022";
        TZ = "America/New_York";
        MONGO_HOST = "${network.nix-server.local.ip}";
        MONGO_PORT = "27017";
      };
      environmentFiles = [
        #config.sops.secrets.mongo_secret.path
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
        #"${toString config.sops.secrets.mongo_init.path}:/docker-entrypoint-initdb.d/init-mongo.js:ro"
      ];
      user = "${toString uid}";
      environment = {
        PUID = "${toString uid}";
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