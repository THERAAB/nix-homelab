{...}: let
  app-name = "syncthing";
  network = import ../../../share/network.properties.nix;
  port = 8384;
  share-dir = "/nix/persist/dropbox";
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "SyncThing";
      url = "https://sync.${network.domain}/";
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
  services.caddy.virtualHosts."sync.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  systemd.tmpfiles.rules = [
    "d    ${share-dir}   -       -             -               -   - "
    "Z    ${share-dir}   740     raab          ${app-name}     -   - "
  ];
  services.syncthing = {
    enable = true;
    relay.enable = false;
    user = "raab";
    configDir = "/nix/persist/home/raab/.config/syncthing";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    guiAddress = "0.0.0.0:${toString port}";
    devices = {
      nix-zenbook = {
        id = "H46DP2U-MISHKSS-EC64UUM-F65VNK4-QTQ2AHP-BO6CRLK-55OAZ2V-QWMGAQS";
        addresses = [ "tcp://${network.nix-zenbook.tailscale.ip}:22000" "tcp://${network.nix-zenbook.local.ip}:22000" ];
      };
    };
    folders = {
      Dropbox = {
        path = "${share-dir}";
        devices = ["nix-zenbook"];
        versioning = {
          type = "staggered";
          params.maxAge = "7776000"; # 90 days
        };
      };
    };
  };
}
