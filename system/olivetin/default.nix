{ config, pkgs, ... }:
let
  port = 1337;
  app-name = "olivetin";
  local-config-dir = "/nix/persist/${app-name}";
  uid = 1778;
  gid = 1778;
in
{
  users = {
    groups.${app-name}.gid = gid;
    users.${app-name} = {
      group = app-name;
      uid = uid;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}                   -       -             -               -   - "
    "r    ${local-config-dir}/config.yaml       -       -             -               -   - "
    "C    ${local-config-dir}/config.yaml       -       -             -               -   - "
    "Z    ${local-config-dir}                   740     ${app-name}   ${app-name}     -   - "
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
    image = "docker.io/jamesread/${app-name}";
    volumes = [
      "${local-config-dir}:/config"
      # "/var/run/docker.sock:/var/run/docker.sock"
    ];
    user = "${toString uid}";
    ports = [ "${toString port}:${toString port}" ];
    environment = {
        PUID="${toString uid}";
        PGID="${toString gid}";
        UMASK="022";
        TZ="America/New_York";
    };
    extraOptions = [
      ""
    ];
  };
}