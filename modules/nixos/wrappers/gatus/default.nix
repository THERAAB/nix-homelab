{
  lib,
  config,
  properties,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.gatus;
  uid = 901;
  gid = 901;
  port = properties.ports.gatus;
  app-name = "gatus";
  local-config-dir = "/var/lib/${app-name}";
in {
  options.nix-homelab.wrappers.gatus = with types; {
    enable = mkEnableOption (lib.mdDoc "Gatus");
    conf = mkOption {
      type = with types;
        nullOr (submodule {
          freeformType = (pkgs.formats.yaml {}).type;
        });
    };
  };
  config = mkIf cfg.enable {
    nix-homelab.services.yamlConfigMaker = {
      gatus = {
        path = "${local-config-dir}/config.yaml";
        settings = {
          alerting = cfg.conf.alerting;
          endpoints = cfg.conf.endpoints;
        };
      };
    };
    users = {
      groups.${app-name}.gid = gid;
      users.${app-name} = {
        group = "${app-name}";
        uid = uid;
        isSystemUser = true;
      };
    };
    systemd = {
      tmpfiles.rules = [
        "d    ${local-config-dir}   -       -             -               -   - "
        "Z    ${local-config-dir}   -       ${app-name}   ${app-name}     -   - "
      ];
      services = {
        # Add secret for gotify
        "yamlPatcher-${app-name}" = {
          script = ''
            TOKEN=`cat /run/secrets/gotify_gatus_token`
            ${pkgs.gnused}/bin/sed -i "s|<PLACEHOLDER>|$TOKEN|" ${local-config-dir}/config.yaml
          '';
          wantedBy = ["yamlConfigMaker-gatus.service"];
          after = ["yamlConfigMaker-gatus.service"];
        };
        "podman-${app-name}" = {
          wantedBy = ["yamlPatcher-${app-name}.service"];
          after = ["yamlPatcher-${app-name}.service" "adguardhome.service"];
        };
      };
    };
    virtualisation.oci-containers.containers."${app-name}" = {
      autoStart = true;
      image = "docker.io/twinproduction/${app-name}:latest";
      volumes = [
        "${local-config-dir}:/config"
      ];
      ports = ["${toString port}:8080"];
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
  };
}
