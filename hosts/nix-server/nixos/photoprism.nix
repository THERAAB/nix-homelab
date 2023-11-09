{config, ...}: let
  port = 2342;
  app-name = "photoprism";
  network = import ../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Photoprism";
      url = "http://${app-name}.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>PhotoPrism</title>*)''
      ];
      alerts = [
        {
          type = "custom";
        }
      ];
      client.insecure = true;
    }
  ];
  services.olivetin.settings.actions = [
    {
      title = "Restart PhotoPrism";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -s ${app-name}";
      timeout = 20;
    }
  ];
  services.caddy.virtualHosts = {
    "http://${app-name}.${network.domain}".extraConfig = ''
      http://reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  networking.firewall.allowedTCPPorts = [port];
  services.${app-name} = {
    enable = true;
    settings = {
      PHOTOPRISM_ADMIN_USER = "raab";
      PHOTOPRISM_UPLOAD_NSFW = "true";
      PHOTOPRISM_ORIGINALS_LIMIT = "-1";
    };
    address = "0.0.0.0";
    originalsPath = "/var/lib/private/photoprism/originals";
    passwordFile = config.sops.secrets.df_password.path;
  };
}
