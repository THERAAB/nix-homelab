{...}: let
  media = import ./media.properties.nix;
  uid = 9991;
  port = 5055;
  app-name = "jellyseerr";
  display-name = "Jellyseerr";
  local-config-dir = "/var/lib/${app-name}";
  network = import ../../../share/network.properties.nix;
in {
  services = {
    yamlConfigMaker = {
      gatus.settings.endpoints = [
        {
          name = "${display-name}";
          url = "https://${app-name}.${network.domain}/health";
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
    };
    caddy.virtualHosts."${app-name}.${network.domain}" = {
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
