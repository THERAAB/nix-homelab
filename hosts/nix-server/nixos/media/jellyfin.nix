{...}: let
  media = import ./media.properties.nix;
  uid = 9992;
  port = 8096;
  app-name = "jellyfin";
  display-name = "Jellyfin";
  local-config-dir = "/var/lib/${app-name}/";
  network = import ../../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
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
  services.olivetin.settings.actions = [
    {
      title = "Restart ${display-name}";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /var/lib/olivetin/scripts/commands.sh -s podman-${app-name}";
      timeout = 20;
    }
  ];
  users = {
    users."${app-name}" = {
      group = "media";
      extraGroups = ["render" "video"];
      uid = uid;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}     -       -             -        -   - "
    "Z    ${local-config-dir}     740     ${app-name}   -        -   - "
  ];
  systemd.services."podman-${app-name}".after = ["multi-user.target"]; # Delay jellyfin start for hardware encoding
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
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
      PGID = "${toString media.gid}";
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
  virtualisation.oci-containers.containers."${app-name}-vue" = {
    autoStart = true;
    image = "ghcr.io/jellyfin/${app-name}-vue:unstable";
    ports = ["5099:80"];
    environment = {
      PUID = "${toString uid}";
      PGID = "${toString media.gid}";
      UMASK = "022";
      TZ = "America/New_York";
      DEFAULT_SERVERS = "jellyfin.pumpkin.rodeo";
      HISTORY_ROUTER_MODE = "0";
    };
    extraOptions = [
      "--device=/dev/dri/renderD128:/dev/dri/renderD128"
      "--device=/dev/dri/card0:/dev/dri/card0"
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
