{...}: let
  gid = 4444;
  uid = 4444;
  port = 8082;
  app-name = "homer";
  system-icons-dir = "/nix/persist/nix-homelab/share/assets/icons";
  config-dir = "/var/lib/${app-name}/";
  config = import ./config.nix;
  network = import ../../../../../../share/network.properties.nix;
  display-name = "Homer";
  environment = {
    UMASK = "022";
    INIT_ASSETS = "0";
    TZ = "America/New_York";
  };
in {
  services = {
    yamlConfigMaker = {
      "${app-name}" = {
        path = "${config-dir}/config.yml";
        settings = config;
      };
      gatus.settings.endpoints = [
        {
          name = "${display-name}";
          url = "https://${network.domain}/";
          conditions = [
            "[STATUS] == 200"
            ''[BODY] == pat(*<div id="app-mount"></div>*)''
          ];
          alerts = [
            {
              type = "gotify";
            }
          ];
        }
      ];
    };
    olivetin.settings.actions = [
      {
        title = "Restart ${display-name}";
        icon = ''<img src = "customIcons/pwa-192x192.png" width = "48px"/>'';
        shell = "sudo /var/lib/olivetin/scripts/commands.sh -s podman-${app-name}";
        timeout = 20;
      }
    ];
    caddy.virtualHosts."${network.domain}" = {
      useACMEHost = "${network.domain}-tld";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${config-dir}                 -   -               -               -   -                     "
    "R    ${config-dir}/icons           -   -               -               -   -                     "
    "C    ${config-dir}/icons           -   -               -               -   ${system-icons-dir}   "
    "Z    ${config-dir}                 -   ${app-name}     ${app-name}     -   -                     "
  ];
  microvm.shares = {
    proto = "virtiofs";
    source = "${config-dir}/icons";
    mountPoint = "${config-dir}/icons";
  };
  users = {
    groups.${app-name}.gid = gid;
    users.${app-name} = {
      group = app-name;
      uid = uid;
      isSystemUser = true;
    };
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "docker.io/b4bz/${app-name}";
    volumes = [
      "${config-dir}:/www/assets"
    ];
    ports = ["${toString port}:8080"];
    user = "${toString uid}";
    environment = environment;
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
