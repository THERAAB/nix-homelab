{ config, pkgs, ... }:
let
  uid = 901;
  gid = 901;
  port = 7000;
  app-name = "gatus";
  local-config-dir = "/nix/persist/${app-name}/";
  cfg = import ./config.nix;
in
{
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
      icon = ''<img src = "customIcons/gatus.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p gatus";
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
  # We have some stuff we want to fix about this generated yaml
  # Mainly add secret for pushbullet and remove quptes from json body
  systemd.services."yamlPatcher-gatus" = {
    script = ''
      # Update pushbullet api key
      TOKEN=`cat ${config.sops.secrets.pushbullet_api_key.path}`
      ${pkgs.gnused}/bin/sed -i "s|<PLACEHOLDER>|$TOKEN|" ${local-config-dir}/config.yaml

      # remove quotes from body:
      ${pkgs.gnused}/bin/sed -i "s/body: '\({.*}\)'/body: \1/" ${local-config-dir}/config.yaml
    '';
    wantedBy = [ "yamlConfigMaker-gatus.service" ];
    after = [ "yamlConfigMaker-gatus.service" ];

  };
  # Delay gatus start because it needs adguard to setup first
  # Otherwise local DNS record lookups will fail.
  systemd.services."podman-${app-name}" = {
    wantedBy = [ "yamlPatcher-gatus.service" ];
    after = [ "yamlPatcher-gatus.service" "adguardhome.service" ];
  };

  services.caddy.virtualHosts = {
    "http://${app-name}.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = false;
    image = "twinproduction/${app-name}";
    volumes = [
      "${local-config-dir}:/config"
    ];
    ports = [ "${toString port}:8080" ];
    environment = {
      PUID="${toString uid}";
      PGID="${toString gid}";
      UMASK="022";
      TZ="America/New_York";
    };
  };
}