{ config, pkgs, ... }:
let
  gid = 4444;
  uid = 4444;
  box-port = 8082;
  tail-port = 8083;
  app-name = "homer";
  system-app-dir = "/nix/persist/nix-homelab/system/${app-name}/";
  system-config-dir = system-app-dir + "/config/";
  local-config-dir = "/nix/persist/${app-name}/";
  tail-config-dir = local-config-dir + "/tail/";
  box-config-dir = local-config-dir + "/box/";
  environment = {
    UMASK="022";
    INIT_ASSETS = "0";
    TZ="America/New_York";
  };
in
{
  imports = [
    ../modules/nixos/olivetin
    ../modules/nixos/yamlConfigMaker
  ];

  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Homer.box";
      url = "http://server.box/";
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
    {
      name = "Homer.tail";
      url = "http://server.tail/";
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
    {
      title = "Restart Homer.tail";
      icon = ''<img src = "customIcons/pwa-192x192.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p homer.tail";
      timeout = 20;
    }
  ];
  systemd.tmpfiles.rules = [
    "r    ${box-config-dir}/config.yml      -   -               -               -   -                                       "
    "r    ${tail-config-dir}/config.yml     -   -               -               -   -                                       "
    "R    ${box-config-dir}/icons           -   -               -               -   -                                       "
    "R    ${tail-config-dir}/icons          -   -               -               -   -                                       "
    "C    ${tail-config-dir}                -   -               -               -   ${system-config-dir}                    "
    "C    ${box-config-dir}                 -   -               -               -   ${system-config-dir}                    "
    "C    ${tail-config-dir}/icons          -   -               -               -   /nix/persist/nix-homelab/assets/icons   "
    "C    ${box-config-dir}/icons           -   -               -               -   /nix/persist/nix-homelab/assets/icons   "
    "C    ${box-config-dir}/config.yml      -   -               -               -   ${system-app-dir}/box.yml               "
    "C    ${tail-config-dir}/config.yml     -   -               -               -   ${system-app-dir}/tail.yml              "
    "Z    ${local-config-dir}               -   ${app-name}     ${app-name}     -   -                                       "
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
    "http://server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString box-port}
    '';
    "http://server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString tail-port}
    '';
  };
  virtualisation.oci-containers.containers."${app-name}.box" = {
    autoStart = true;
    image = "b4bz/${app-name}";
    volumes = [
      "${box-config-dir}:/www/assets"
    ];
    ports = [ "${toString box-port}:8080" ];
    user = "${toString uid}";
    environment = environment;
  };
  virtualisation.oci-containers.containers."${app-name}.tail" = {
    autoStart = true;
    image = "b4bz/${app-name}";
    volumes = [
      "${tail-config-dir}:/www/assets"
    ];
    ports = [ "${toString tail-port}:8080" ];
    user = "${toString uid}";
    environment = environment;
  };
}