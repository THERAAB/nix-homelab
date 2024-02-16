{pkgs, ...}: let
  uid = 901;
  gid = 901;
  port = 7000;
  app-name = "gatus";
  display-name = "Gatus";
  local-config-dir = "/var/lib/${app-name}/";
  cfg = import ./config.nix;
  network = import ../../../../../../share/network.properties.nix;
in {
  services = {
    yamlConfigMaker = {
      gatus = {
        path = "${local-config-dir}/config.yaml";
        settings = {
          alerting = cfg.alerting;
          endpoints = cfg.endpoints;
        };
      };
    };
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
        reverse_proxy 127.0.0.1:${toString port}
      '';
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
      # Delay gatus start because it needs adguard to setup first
      # Otherwise local DNS record lookups will fail.
      "podman-${app-name}" = {
        wantedBy = ["yamlPatcher-${app-name}.service"];
        after = ["yamlPatcher-${app-name}.service" "adguardhome.service"];
      };
    };
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = false;
    image = "docker.io/twinproduction/${app-name}";
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
}
