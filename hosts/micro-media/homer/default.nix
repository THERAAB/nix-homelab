{...}: let
  gid = 4444;
  uid = 4444;
  port = 8082;
  app-name = "homer";
  system-icons-dir = "/nix/persist/nix-homelab/share/assets/icons";
  local-config-dir = "/var/lib/${app-name}";
  config = import ./config.nix;
  network = import ../../../share/network.properties.nix;
  display-name = "Homer";
  environment = {
    UMASK = "022";
    INIT_ASSETS = "0";
    TZ = "America/New_York";
  };
in {
  microvm.shares = [
    {
      proto = "virtiofs";
      source = system-icons-dir;
      mountPoint = "${local-config-dir}/icons";
      tag = "${app-name}-icons";
    }
  ];
  services = {
    yamlConfigMaker = {
      "${app-name}" = {
        path = "${local-config-dir}/config.yml";
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
    caddy.virtualHosts."${network.domain}" = {
      useACMEHost = "${network.domain}-tld";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy ${network.micro-media.local.ip}:${toString port}
      '';
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}                 -   -               -               -   -                     "
    "Z    ${local-config-dir}                 -   ${app-name}     ${app-name}     -   -                     "
  ];
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
      "${local-config-dir}:/www/assets"
    ];
    ports = ["${toString port}:8080"];
    user = "${toString uid}";
    environment = environment;
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
