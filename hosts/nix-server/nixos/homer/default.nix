{...}: let
  gid = 4444;
  uid = 4444;
  port = 8082;
  app-name = "homer";
  system-icons-dir = "/nix/persist/nix-homelab/share/assets/icons";
  local-config-dir = "/nix/persist/${app-name}/";
  config = import ./config.nix;
  config-dir = local-config-dir;
  network = import ../../../../share/network.properties.nix;
  homer-hostname = "server";
  environment = {
    UMASK = "022";
    INIT_ASSETS = "0";
    TZ = "America/New_York";
  };
in {
  services.yamlConfigMaker."homer" = {
    path = "${config-dir}/config.yml";
    settings = config;
  };
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Homer.box";
      url = "http://${homer-hostname}.${network.domain.box}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<div id="app-mount"></div>*)''
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
      title = "Restart Homer";
      icon = ''<img src = "customIcons/pwa-192x192.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p homer";
      timeout = 20;
    }
  ];
  systemd.tmpfiles.rules = [
    "R    ${config-dir}/icons           -   -               -               -   -                     "
    "C    ${config-dir}/icons           -   -               -               -   ${system-icons-dir}   "
    "Z    ${local-config-dir}               -   ${app-name}     ${app-name}     -   -                     "
  ];
  users = {
    groups.${app-name}.gid = gid;
    users.${app-name} = {
      group = app-name;
      uid = uid;
      isSystemUser = true;
    };
  };
  services.caddy.virtualHosts = {
    "http://${homer-hostname}.${network.domain.box}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "b4bz/${app-name}";
    volumes = [
      "${config-dir}:/www/assets"
    ];
    ports = ["${toString port}:8080"];
    user = "${toString uid}";
    environment = environment;
  };
}
