{
  config,
  pkgs,
  ...
}: let
  uid = 901;
  gid = 901;
  port = 7000;
  app-name = "gatus";
  local-config-dir = "/nix/persist/${app-name}/";
  cfg = import ./config.nix;
  network = import ../../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus = {
    path = "${local-config-dir}/config.yaml";
    settings = {
      alerting = cfg.alerting;
      endpoints = cfg.endpoints;
    };
  };
  services.olivetin.settings.actions = [
    {
      title = "Restart Gatus";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p ${app-name}";
      timeout = 20;
    }
  ];
  users = {
    groups.${app-name}.gid = gid;
    users.${app-name} = {
      group = "${app-name}";
      uid = uid;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}   -       -             -               -   - "
    "Z    ${local-config-dir}   740     ${app-name}   ${app-name}     -   - "
  ];
  # Add secret for pushbullet
  systemd.services."yamlPatcher-${app-name}" = {
    script = ''
      # Update pushbullet api key
      TOKEN=`cat ${config.sops.secrets.pushbullet_api_key.path}`
      ${pkgs.gnused}/bin/sed -i "s|<PLACEHOLDER>|$TOKEN|" ${local-config-dir}/config.yaml
    '';
    wantedBy = ["yamlConfigMaker-gatus.service"];
    after = ["yamlConfigMaker-gatus.service"];
  };
  # Delay gatus start because it needs adguard to setup first
  # Otherwise local DNS record lookups will fail.
  systemd.services."podman-${app-name}" = {
    wantedBy = ["yamlPatcher-${app-name}.service"];
    after = ["yamlPatcher-${app-name}.service" "adguardhome.service"];
  };

  services.caddy.virtualHosts = {
    "http://${app-name}.${network.domain.local}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
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
