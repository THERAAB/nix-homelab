{...}: let
  app-name = "syncthing";
  network = import ../../../share/network.properties.nix;
  port = 8384;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "SyncThing";
      url = "https://${app-name}.${network.domain}/";
      conditions = [
        "[STATUS] == 401"
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
      title = "Restart SyncThing";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /var/lib/olivetin/scripts/commands.sh -s ${app-name}";
      timeout = 20;
    }
  ];
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  services.syncthing = {
    enable = true;
    user = "raab";
    configDir = "/nix/persist/home/raab/.config/syncthing";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    guiAddress = "0.0.0.0:${toString port}";
    devices = {
      nix-zenbook = {
        id = "H46DP2U-MISHKSS-EC64UUM-F65VNK4-QTQ2AHP-BO6CRLK-55OAZ2V-QWMGAQS";
        addresses = [ "tcp://${network.nix-zenbook.tailscale.ip}:22000" ];
      };
    };
    folders = {
      Share = {
        path = "/home/raab/Documents";
        devices = ["nix-zenbook"];
      };
    };
  };
}
