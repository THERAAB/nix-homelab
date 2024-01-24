{
  pkgs,
  config,
  ...
}: let
  port = 2342;
  app-name = "photoprism";
  display-name = "Photoprism";
  network = import ../../../share/network.properties.nix;
  originals-dir = "/var/lib/private/photoprism/originals";
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "${display-name}";
      url = "https://photos.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>PhotoPrism</title>*)''
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
      shell = "sudo /var/lib/olivetin/scripts/commands.sh -s ${app-name}";
      timeout = 20;
    }
  ];
  services.caddy.virtualHosts."photos.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  fileSystems."${originals-dir}" = {
    device = "/sync/Camera";
    options = ["bind"];
  };
  users = {
    groups.photoprism = {};
    users.${app-name} = {
      group = app-name;
      isSystemUser = true;
      extraGroups = ["syncthing"];
    };
  };
  systemd = {
    services."${app-name}-index-refresh" = {
      script = ''
        su -c "${pkgs.photoprism}/bin/${app-name} index --cleanup" photoprism
      '';
      after = ["${app-name}.service"];
      requires = ["${app-name}.service"];
      path = with pkgs; [
        su
      ];
    };
    timers."${app-name}-index-refresh" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = "true";
        Unit = "${app-name}-index-refresh.service";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [port];
  services.${app-name} = {
    enable = true;
    settings = {
      PHOTOPRISM_ADMIN_USER = "raab";
      PHOTOPRISM_UPLOAD_NSFW = "true";
      PHOTOPRISM_ORIGINALS_LIMIT = "-1";
      PHOTOPRISM_READONLY = "true";
    };
    address = "0.0.0.0";
    originalsPath = "${originals-dir}";
    passwordFile = config.sops.secrets.df_password.path;
  };
}
