{ config, pkgs, ... }:
let
  media = (import ./properties.nix).media;
  uid = 9993;
  port = 9696;
  app-name = "prowlarr";
  local-config-dir = media.dir.config + "/${app-name}/";
in
{
  users = {
    users."${app-name}" = {
      group = "media";
      uid = uid;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}     -       -             -        -   - "
    "Z    ${local-config-dir}     740     ${app-name}   media    -   - "
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
    image = "linuxserver/${app-name}:develop";
    volumes = [
      "${local-config-dir}:/config"
    ];
    ports = [ "${toString port}:${toString port}" ];
    environment = {
      PUID="${toString uid}";
      PGID="${toString media.gid}";
      UMASK="022";
      TZ="America/New_York";
    };
  };
}