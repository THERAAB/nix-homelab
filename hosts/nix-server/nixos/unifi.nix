{...}: let
  uid = 7812;
  gid = 7813;
  port = 8443;
  app-name = "unifi-controller";
  network = import ../../../../share/network.properties.nix;
  local-config-dir = "/nix/persist/${app-name}/";
in {
  users = {
    users."${app-name}" = {
      uid = uid;
      group = app-name;
      isSystemUser = true;
    };
    groups.${app-name}.gid = gid;
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}     -       -             -        -   - "
    "Z    ${local-config-dir}     740     ${app-name}   -        -   - "
  ];
  services.caddy.virtualHosts = {
    "http://${app-name}.${network.domain.local}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.${network.domain.tail}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "linuxserver/${app-name}";
    volumes = [
      "${local-config-dir}:/config"
    ];
    ports = [
      "${toString port}:${toString port}"
      "3478:3478/udp"
      "1001:1001/udp"
      "8080:8080"
    ];
    environment = {
      PUID = "${toString uid}";
      UMASK = "022";
      TZ = "America/New_York";
    };
  };
}
