{...}: let
  media = import ./media.properties.nix;
  uid = 9992;
  port = 8096;
  app-name = "jellyfin";
  local-config-dir = media.dir.config + "/${app-name}/";
  network = import ../../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Jellyfin";
      url = "https://${app-name}.${network.domain}/health";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "custom";
        }
      ];
    }
  ];
  services.olivetin.settings.actions = [
    {
      title = "Restart Jellyfin";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /var/lib/olivetin/scripts/commands.sh -p ${app-name}";
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
    "Z    ${local-config-dir}     740     ${app-name}   media    -   - "
  ];
  # Delay jellyfin start for 60s because hardware encoding fails if run on boot
  # I suspect because jellyfin tries to load before hardware devices become available
  systemd.timers."start-${app-name}" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "60s";
      Unit = "podman-${app-name}.service";
    };
  };
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = false;
    image = "lscr.io/linuxserver/${app-name}";
    volumes = [
      "${local-config-dir}:/config"
      "${media.dir.movies}:/movies"
      "${media.dir.tv}:/tv"
    ];
    ports = ["${toString port}:${toString port}"];
    environment = {
      PUID = "${toString uid}";
      PGID = "${toString media.gid}";
      UMASK = "022";
      TZ = "America/New_York";
      DOCKER_MODS = "linuxserver/mods:jellyfin-opencl-intel";
    };
    extraOptions = [
      "--network=media-network"
      "--device=/dev/dri/renderD128:/dev/dri/renderD128"
      "--device=/dev/dri/card0:/dev/dri/card0"
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
