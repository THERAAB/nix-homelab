{...}: let
  gid = 4444;
  uid = 4444;
  box-port = 8082;
  app-name = "homer";
  system-icons-dir = "/nix/persist/nix-homelab/share/assets/icons";
  local-config-dir = "/nix/persist/${app-name}/";
  box-config = import ./box.nix;
  box-config-dir = local-config-dir + "/box/";
  network = import ../../../../share/network.properties.nix;
  homer-hostname = "server";
  environment = {
    UMASK = "022";
    INIT_ASSETS = "0";
    TZ = "America/New_York";
  };
in {
  services.yamlConfigMaker."homer.box" = {
    path = "${box-config-dir}/config.yml";
    settings = box-config;
  };
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Homer.box";
      url = "http://${homer-hostname}.${network.domain.local}/";
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
      title = "Restart Homer.box";
      icon = ''<img src = "customIcons/pwa-192x192.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p homer.box";
      timeout = 20;
    }
  ];
  systemd.tmpfiles.rules = [
    "R    ${box-config-dir}/icons           -   -               -               -   -                     "
    "C    ${box-config-dir}/icons           -   -               -               -   ${system-icons-dir}   "
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
    "http://${homer-hostname}.${network.domain.local}".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString box-port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}.box" = {
    autoStart = true;
    image = "b4bz/${app-name}";
    volumes = [
      "${box-config-dir}:/www/assets"
    ];
    ports = ["${toString box-port}:8080"];
    user = "${toString uid}";
    environment = environment;
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
