{...}: let
  media = import ./media.properties.nix;
  uid = 9992;
  port = 8096;
  app-name = "jellyfin";
  display-name = "Jellyfin";
  local-config-dir = "/var/lib/${app-name}";
  network = import ../../../share/network.properties.nix;
in {
  services = {
    yamlConfigMaker.gatus.settings.endpoints = [
      {
        name = "${display-name}";
        url = "https://${app-name}.${network.domain}/health";
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
    caddy.virtualHosts."${app-name}.${network.domain}" = {
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
      group = media.group.name;
      isSystemUser = true;
    };
  };
  systemd = {
    tmpfiles.rules = [
      "d    ${local-config-dir}     -       -             -           -   - "
      "Z    ${local-config-dir}     -       ${app-name}   ${media.group.name} -   - "
    ];
    services."podman-${app-name}".after = ["multi-user.target"]; # Delay jellyfin start for hardware encoding
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "lscr.io/linuxserver/${app-name}";
    volumes = [
      "${local-config-dir}:/config"
      "${media.dir.movies}:/movies"
      "${media.dir.tv}:/tv"
    ];
    ports = ["${toString port}:8096"];
    environment = {
      PUID = "${toString uid}";
      PGID = "${toString media.group.id}";
      UMASK = "022";
      TZ = "America/New_York";
      DOCKER_MODS = "linuxserver/mods:jellyfin-opencl-intel";
      JELLYFIN_PublishedServerUrl = "https://${app-name}.${network.domain}";
    };
    extraOptions = [
      "--device=/dev/dri/renderD128:/dev/dri/renderD128"
      "--device=/dev/dri/card0:/dev/dri/card0"
      "-l=io.containers.autoupdate=registry"
    ];
  };
}