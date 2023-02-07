{ config, pkgs, ... }:
let
  gid = 3030;
  uid = 3030;
  port = 3001;
  app-name = "homepage";
  local-config-dir = "/nix/persist/${app-name}/";
in
{
  users = {
    groups."${app-name}".gid = gid;
    users."${app-name}" = {
      group = app-name;
      uid = uid;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}     -       -             -               -   - "
    "Z    ${local-config-dir}     740     ${app-name}   ${app-name}     -   - "
  ];
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
    image = "ghcr.io/benphelps/${app-name}";
    volumes = [
      "${local-config-dir}:/app/config"
    ];
    ports = [ "${toString port}:3001" ];
    environment = {
      PUID="${toString uid}";
      PGID="${toString gid}";
      UMASK="022";
      TZ="America/New_York";
    };
  };
}