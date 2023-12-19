{config, ...}: let
  port = 9080;
  app-name = "microbin";
  network = import ../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Microbin";
      url = "https://${app-name}.${network.domain}";
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
      title = "Restart Microbin";
      icon = ''<img src = "customIcons/microbin.png" width = "48px"/>'';
      shell = "sudo /var/lib/olivetin/scripts/commands.sh -s ${app-name}";
      timeout = 20;
    }
  ];
  networking.firewall.allowedTCPPorts = [port];
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  services.microbin = {
    enable = true;
    passwordFile = config.sops.secrets.df_password.path;
    settings = {
      MICROBIN_PORT = port;
    };
  };
}
