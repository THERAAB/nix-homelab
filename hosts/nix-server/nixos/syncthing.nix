{...}: let
  app-name = "syncthing";
  network = import ../../../share/network.properties.nix;
  port = 8384;
  local-dir = "/nix/persist/dropbox";
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "SyncThing";
      url = "https://sync.${network.domain}/";
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
    "d    ${local-dir}/share  -       -             -               -   - "
    "Z    ${local-dir}        770     syncthing     ${app-name}     -   - "
    "Z    ${local-dir}/share  770     syncthing     ${app-name}     -   - "
  ];
  services.syncthing = {
    enable = true;
    relay.enable = false;
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    guiAddress = "0.0.0.0:${toString port}";
    settings = {
      devices = {
        nix-zenbook = {
          id = "M3OWV56-LFY5O5S-AYUOLEL-AOJN6FS-E3LA3XY-6QUG5MV-TIDRRNY-C3YS7AT";
          addresses = ["tcp://${network.nix-zenbook.tailscale.ip}:22000" "tcp://${network.nix-zenbook.local.ip}:22000"];
        };
        nix-desktop = {
          id = "YEUHTJT-HKSDRRS-FPPJCUU-ZWHQJTR-ZRP3LVM-BYFNSH7-MJ7BGPJ-C6PMFA6";
          addresses = ["tcp://${network.nix-desktop.tailscale.ip}:22000" "tcp://${network.nix-desktop.local.ip}:22000"];
        }
      };
      folders = {
        "${local-dir}/share" = {
          id = "share";
          devices = ["nix-zenbook"];
          versioning = {
            type = "staggered";
            params.maxAge = "7776000"; # 90 days
          };
        };
      };
    };
  };
}
