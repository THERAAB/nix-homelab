{
  lib,
  config,
  properties,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.photoprism;
  port = properties.ports.photoprism;
  app-name = "photoprism";
  originals-dir = "/var/lib/private/photoprism/originals";
in {
  options.nix-homelab.wrappers.photoprism = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
    services.${app-name} = {
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
  };
}
