{...}: let
  media = import ./media.properties.nix;
  uid = 9997;
  port = 8787;
  app-name = "readarr";
  local-config-dir = "/var/lib/${app-name}/";
  network = import ../../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Readarr";
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
      title = "Restart Readarr";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /var/lib/olivetin/scripts/commands.sh -p ${app-name}";
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
    "d    ${local-config-dir}     -       -             -    -   - "
    "Z    ${local-config-dir}     740     ${app-name}   -    -   - "
  ];
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "lscr.io/linuxserver/${app-name}:develop";
    volumes = [
      "${local-config-dir}:/config"
      "${media.dir.audiobooks}:/books"
      "${media.dir.downloads}:/app/qBittorrent/downloads"
    ];
    ports = ["${toString port}:8787"];
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
