{...}: let
  uid = 7812;
  gid = 7813;
  port = 8443;
  app-name = "unifi-controller";
  local-config-dir = "/nix/persist/${app-name}/";
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Unifi Controller";
      url = "https://192.168.3.2:8443";
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
      title = "Restart Unifi";
      icon = ''<img src = "customIcons/unifi.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p ${app-name}";
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
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "linuxserver/${app-name}";
    volumes = [
      "${local-config-dir}:/config"
    ];
    ports = [
      "${toString port}:${toString port}"
      "3478:3478/udp"
      "1001:1001/udp"
      "8080:8080"
    ];
    environment = {
      PUID = "${toString uid}";
      PGID = "${toString gid}";
      UMASK = "022";
      TZ = "America/New_York";
    };
  };
}
