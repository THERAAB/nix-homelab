{
  config,
  lib,
  ...
}:
with lib; let
  network = import ../../network.properties.nix;
  cfg = config.services.podman-application;
  configOpts = {app-name, ...}: {
    options = {
      app-name = mkOption {
        default = null;
        type = with types; nullOr str;
      };
      displayName = mkOption {
        default = name;
        type = with types; nullOr str;
      };
      port = mkOption {
        default = null;
        type = with types; nullOr int;
        description = lib.mdDoc "Port to expose";
        example = "80";
      };
      internalPort = mkOption {
        default = port;
        type = with types; nullOr int;
        description = lib.mdDoc "Port inside image to map to config.port";
        example = "80";
      };
      statusCode = mkOption {
        default = 200;
        type = types.int;
        description = lib.mdDoc "Status code for olivetin to monitor";
      };
      uid = mkOption {
        default = null;
        type = types.int;
        description = lib.mdDoc "User ID of the container";
      };
      gid = mkOption {
        default = null;
        type = types.int;
        description = lib.mdDoc "Group ID of the container";
      };
      autoUpdate = mkOption {
        default = true;
        type = types.bool;
        description = lib.mdDoc "Whether to autoUpdate the podman image";
      };
      dockerImage = mkOption {
        default = null;
        type = with types; nullOr str;
        description = lib.mdDoc "Image name/location";
      };
      internalMountDir = mkOption {
        default = null;
        type = with types; nullOr str;
        description = lib.mdDoc "InternalMountDir";
      };
    };
  };
  local-config-dir = "/var/lib/${cfg.app-name}/";
in {
  options.services.podman-application = mkOption {
    default = {};
    type = types.attrsOf (types.submodule configOpts);
  };
  config = lib.mkIf (cfg != {}) {
    services.yamlConfigMaker.gatus.settings.endpoints = [
      {
        name = cfg.displayName;
        url = "https://${cfg.app-name}.${network.domain}";
        conditions = [
          "[STATUS] == ${cfg.statusCode}"
        ];
        alerts = [
          {
            type = "gotify";
          }
        ];
      }
    ];
    services.olivetin.settings.actions = [
      {
        title = "Restart ${cfg.displayName}";
        icon = ''<img src = "customIcons/${cfg.app-name}.png" width = "48px"/>'';
        shell = "sudo /var/lib/olivetin/scripts/commands.sh -s podman-${cfg.app-name}";
        timeout = 20;
      }
    ];
    users = {
      users."${cfg.app-name}" = {
        uid = cfg.uid;
        group = cfg.app-name;
        isSystemUser = true;
      };
      groups.${cfg.app-name}.gid = cfg.gid;
    };
    systemd.tmpfiles.rules = [
      "d    ${local-config-dir}     -       -               - -   - "
      "Z    ${local-config-dir}     740     ${cfg.app-name} - -   - "
    ];
    services.caddy.virtualHosts."${cfg.app-name}.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString cfg.port}
      '';
    };
    virtualisation.oci-containers.containers.${app-name} = {
      autoStart = true;
      image = "${cfg.dockerImage}";
      volumes = [
        "${local-config-dir}:${internalMountDir}"
      ];
      ports = [
        "${toString cfg.port}:${toString cfg.internalPort}"
      ];
      environment = {
        PUID = "${toString cfg.uid}";
        PGID = "${toString cfg.gid}";
        UMASK = "022";
        TZ = "America/New_York";
      };
      extraOptions = mkIf cfg.autoUpdate [
        "-l=io.containers.autoupdate=registry"
      ];
    };
  };
}
