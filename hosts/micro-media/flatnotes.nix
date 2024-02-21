{...}: let
  uid = 7762;
  gid = 7763;
  port = 9092;
  app-name = "flatnotes";
  display-name = "Flatnotes";
  local-config-dir = "/var/lib/${app-name}";
  network = import ../../share/network.properties.nix;
in {
  services = {
    yamlConfigMaker.gatus.settings.endpoints = [
      {
        name = "${display-name}";
        url = "https://notes.${network.domain}";
        conditions = [
          "[STATUS] == 200"
        ];
        alerts = [
          {
            type = "gotify";
          }
        ];
      }
    ];
    caddy.virtualHosts."notes.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy ${network.micro-media.local.ip}:${toString port}
      '';
    };
  };
  users = {
    users."${app-name}" = {
      uid = uid;
      group = app-name;
      isSystemUser = true;
    };
    groups.${app-name}.gid = gid;
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}     -       -             -   -   - "
    "Z    ${local-config-dir}     -       ${app-name}   -   -   - "
  ];
  #fileSystems."/sync/share/${app-name}" = {
  #  device = "${local-config-dir}";
  #  options = ["bind"];
  #};
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "docker.io/dullage/${app-name}";
    volumes = [
      "${local-config-dir}:/data"
    ];
    ports = [
      "${toString port}:8080"
    ];
    environment = {
      PUID = "${toString uid}";
      PGID = "${toString gid}";
      UMASK = "022";
      TZ = "America/New_York";
      FLATNOTES_AUTH_TYPE = "none";
    };
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
