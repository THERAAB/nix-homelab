{...}: let
  uid = 7762;
  gid = 7763;
  port = 9092;
  app-name = "flatnotes";
  display-name = "Flatnotes";
  local-config-dir = "/var/lib/${app-name}/";
  network = import ../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "${display-name}";
      url = "https://${app-name}.${network.domain}";
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
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
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
