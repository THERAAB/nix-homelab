{ config, pkgs, ... }:
let
  uid = 901;
  gid = 901;
  port = 7000;
  app-name = "gatus";
  local-config-dir = "/nix/persist/${app-name}/";

  cfg = (import ./config.nix);
#  format = pkgs.formats.yaml {};
#  configFile = pkgs.runCommand "config.yaml" { preferLocalBuild = true; } ''
#    cp ${format.generate "config.yaml" cfg.settings} $out
#  '';
in
{
  imports = [
    ../../modules/nixos/olivetin
    ../../modules/nixos/yamlConfigMaker
  ];

  services.yamlConfigMaker.configFiles.gatus = {
    path = "${local-config-dir}/config.yaml";
    fileContents.alerting = cfg.settings.alerting;
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
  systemd.services."yamlSecretAdder-gatus" = {
    script = ''
      TOKEN=`cat ${config.sops.secrets.pushbullet_api_key.path}`
      ${pkgs.gnused}/bin/sed -i "s|<PLACEHOLDER>|$TOKEN|" ${local-config-dir}/config.yaml
    '';
    wantedBy = [ "yamlConfigMaker-gatus.service" ];
    after = [ "yamlConfigMaker-gatus.service" ];
  };
  # Delay gatus start for 30s because it needs adguard to setup first
  # Otherwise local DNS record lookups will fail.
  # There's a smarter way to do this with wanted and after, but this is the lazy way
  systemd.timers."start-${app-name}" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "30s";
      Unit = "podman-${app-name}.service";
    };
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