{...}: let
  uid = 7642;
  gid = 7643;
  port = 9940;
  app-name = "filebrowser";
  display-name = "File Browser";
  local-config-dir = "/var/lib/${app-name}";
  dir-to-share = "/sync";
  network = import ../../../share/network.properties.nix;
in {
  services = {
    yamlConfigMaker.gatus.settings.endpoints = [
      {
        name = "${display-name}";
        url = "https://files.${network.domain}";
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
    caddy.virtualHosts."files.${network.domain}" = {
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
      group = app-name;
      isSystemUser = true;
      extraGroups = ["syncthing" "photoprism" "flatnotes"];
    };
    groups.${app-name}.gid = gid;
  };
  systemd.tmpfiles.rules = [
    "d    ${dir-to-share}                 -       -             -           -   - "
    "d    ${local-config-dir}             -       -             -           -   - "
    "f    ${local-config-dir}/database.db -       -             -           -   - "
    "Z    ${local-config-dir}             -       ${app-name}   ${app-name} -   - "
  ];
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "docker.io/${app-name}/${app-name}";
    volumes = [
      "${dir-to-share}:/srv"
      "${local-config-dir}/database.db:/database.db"
    ];
    ports = [
      "${toString port}:80"
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