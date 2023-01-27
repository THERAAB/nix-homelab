{ config, pkgs, ... }:
let
  uid = 901;
  gid = 901;
  port = 7000;
  app-name = "gatus";
  local-config-dir = "/nix/persist/${app-name}/";
  system-app-dir = "/nix/persist/server/system/${app-name}/";
in
{
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
  system.activationScripts."gatus-secrets" = ''
    cp ${system-app-dir}/config.yaml ${local-config-dir}/config.yaml
    SECRET=`cat ${config.sops.secrets.pushbullet_api_key.path}`
    ${pkgs.gnused}/bin/sed -i "s|<PLACEHOLDER>|$SECRET|" ${local-config-dir}/config.yaml
  '';
  services.caddy.virtualHosts = {
    "http://${app-name}.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
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