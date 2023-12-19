{
  config,
  lib,
  ...
}:
with lib; let
  network = import ../network.properties.nix;
  cfg = config.services.podman-application;
  configOpts = {app-name, ...}: {
    options = {
      app-name = mkOption {
        default = null;
        type = with types; nullOr str;
      };
      displayName = mkOption {
        default = null;
        type = with types; nullOr str;
      };
      port = mkOption {
        default = null;
        type = with types; nullOr int;
        description = lib.mdDoc "Port to expose";
        example = "80";
      };
      internalPort = mkOption {
        default = cfg.port;
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
in {
  options.services.podman-application = mkOption {
    type = with types; attrsOf (submodule configOpts);
  };
  config = {
    #services.yamlConfigMaker.gatus.settings.endpoints =
    #  mapAttrs' (app-name: value: [
    #    {
    #      name = value.displayName;
    #      url = "https://${app-name}.${network.domain}";
    #      conditions = [
    #        "[STATUS] == ${value.statusCode}"
    #      ];
    #      alerts = [
    #        {
    #          type = "gotify";
    #        }
    #      ];
    #    }
    #  ])
    #  cfg;
    #services.olivetin.settings.actions =
    #  mapAttrs' (app-name: value: [
    #    {
    #      title = "Restart ${value.displayName}";
    #      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
    #      shell = "sudo /var/lib/olivetin/scripts/commands.sh -s podman-${app-name}";
    #      timeout = 20;
    #    }
    #  ])
    #  cfg;
    #users =
    #  mapAttrs' (app-name: value: {
    #    users."${app-name}" = {
    #      uid = value.uid;
    #      group = app-name;
    #      isSystemUser = true;
    #    };
    #    groups.${app-name}.gid = value.gid;
    #  })
    #  cfg;
    systemd.tmpfiles =
      mapAttrs' (app-name: value: "rules" {
        rules = [
          "d    /var/lib/${app-name}/     -       -             - -   - "
          "Z    /var/lib/${app-name}/     740     ${app-name}   - -   - "
        ];
      })
      cfg;
    #services.caddy.virtualHosts =
    #  mapAttrs' (app-name: value: {
    #    "${app-name}.${network.domain}" = {
    #      useACMEHost = "${network.domain}";
    #      extraConfig = ''
    #        encode zstd gzip
    #        reverse_proxy 127.0.0.1:${toString value.port}
    #      '';
    #    };
    #  })
    #  cfg;
    #virtualisation.oci-containers.containers =
    #  mapAttrs' (app-name: value: {
    #    "${app-name}" = {
    #      autoStart = true;
    #      image = "${value.dockerImage}";
    #      volumes = [
    #        "/var/lib/${app-name}:${value.internalMountDir}"
    #      ];
    #      ports = [
    #        "${toString value.port}:${toString value.internalPort}"
    #      ];
    #      environment = {
    #        PUID = "${toString value.uid}";
    #        PGID = "${toString value.gid}";
    #        UMASK = "022";
    #        TZ = "America/New_York";
    #      };
    #      extraOptions = mkIf value.autoUpdate [
    #        "-l=io.containers.autoupdate=registry"
    #      ];
    #    };
    #  })
    #  cfg;
  };
}
