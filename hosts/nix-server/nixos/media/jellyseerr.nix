{...}: let
  media = import ./media.properties.nix;
  uid = 9991;
  port = 5055;
  app-name = "jellyseerr";
  local-config-dir = media.dir.config + "/${app-name}/";
  network = import ../../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Jellyseerr";
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
      title = "Restart Jellyseerr";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p ${app-name}";
      timeout = 20;
    }
  ];
  users = {
    users."${app-name}" = {
      group = "media";
      uid = uid;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}     -       -           -           -   - "
    "Z    ${local-config-dir}     740     ${app-name} media       -   - "
  ];
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "docker.io/fallenbagel/${app-name}";
    volumes = [
      "${local-config-dir}:/app/config"
      "${media.dir.movies}:/movies"
      "${media.dir.tv}:/tv"
    ];
    ports = ["${toString port}:${toString port}"];
    environment = {
      PUID = "${toString uid}";
      PGID = "${toString media.gid}";
      UMASK = "022";
      TZ = "America/New_York";
    };
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
