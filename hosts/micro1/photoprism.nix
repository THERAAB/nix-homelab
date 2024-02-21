{pkgs, ...}: let
  port = 2342;
  app-name = "photoprism";
  display-name = "Photoprism";
  network = import ../../share/network.properties.nix;
  originals-dir = "/var/lib/private/photoprism/originals";
in {
  services = {
    yamlConfigMaker.gatus.settings.endpoints = [
      {
        name = "${display-name}";
        url = "https://photos.${network.domain}/";
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<title>PhotoPrism</title>*)''
        ];
        alerts = [
          {
            type = "gotify";
          }
        ];
      }
    ];
    caddy.virtualHosts."photos.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy ${network.micro1.local.ip}:${toString port}
      '';
    };
    ${app-name} = {
      enable = true;
      settings = {
        PHOTOPRISM_ADMIN_USER = "raab";
        PHOTOPRISM_UPLOAD_NSFW = "true";
        PHOTOPRISM_ORIGINALS_LIMIT = "-1";
        PHOTOPRISM_READONLY = "true";
      };
      address = "0.0.0.0";
      originalsPath = "${originals-dir}";
      passwordFile = "/run/secrets/df_password";
    };
  };
  #fileSystems."${originals-dir}" = {
  #  device = "/sync/Camera";
  #  options = ["bind"];
  #};
  users = {
    groups.photoprism = {};
    users.${app-name} = {
      group = app-name;
      isSystemUser = true;
    };
  };
  systemd = {
    services."${app-name}-index-refresh" = {
      script = ''
        export PHOTOPRISM_ADMIN_USER='raab'
        export PHOTOPRISM_HTTP_HOST='0.0.0.0'
        export PHOTOPRISM_HTTP_PORT='2342'
        export PHOTOPRISM_IMPORT_PATH='import'
        export PHOTOPRISM_ORIGINALS_LIMIT='-1'
        export PHOTOPRISM_ORIGINALS_PATH='/var/lib/private/photoprism/originals'
        export PHOTOPRISM_READONLY='true'
        export PHOTOPRISM_STORAGE_PATH='/var/lib/photoprism'
        export PHOTOPRISM_UPLOAD_NSFW='true'
        exec ${pkgs.photoprism}/bin/photoprism index --cleanup
      '';
      after = ["${app-name}.service"];
      requires = ["${app-name}.service"];
    };
    timers."${app-name}-index-refresh" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = "true";
        Unit = "${app-name}-index-refresh.service";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [port];
}
