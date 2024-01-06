{...}: let
  app-name = "syncthing";
  display-name = "SyncThing";
  network = import ../../../share/network.properties.nix;
  port = 8384;
  local-dir = "/sync";
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "${display-name}";
      url = "https://sync.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
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
  services.caddy.virtualHosts."sync.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
  systemd.tmpfiles.rules = [
    "d    ${local-dir}         -       -             -               -   - "
    "d    ${local-dir}/share   -       -             -               -   - "
    "d    ${local-dir}/Camera  -       -             -               -   - "
    "Z    ${local-dir}/share   770     ${app-name}   ${app-name}     -   - "
    # "Z    ${local-dir}/Camera  770     ${app-name}   ${app-name}     -   - "
  ];
  # users.users.${app-name}.extraGroups = ["photoprism"];
  services.syncthing = {
    enable = true;
    relay.enable = false;
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = false;
    guiAddress = "0.0.0.0:${toString port}";
    settings = {
      options.urAccepted = -1;
      devices = {
        nix-zenbook = {
          id = "M3OWV56-LFY5O5S-AYUOLEL-AOJN6FS-E3LA3XY-6QUG5MV-TIDRRNY-C3YS7AT";
          addresses = ["tcp://${network.nix-zenbook.tailscale.ip}:22000" "tcp://${network.nix-zenbook.local.ip}:22000"];
        };
        nix-desktop = {
          id = "YEUHTJT-HKSDRRS-FPPJCUU-ZWHQJTR-ZRP3LVM-BYFNSH7-MJ7BGPJ-C6PMFA6";
          addresses = ["tcp://${network.nix-desktop.tailscale.ip}:22000" "tcp://${network.nix-desktop.local.ip}:22000"];
        };
        galaxy-s7-tab.id = "STQ62IM-HAMN7JJ-AXKOFPA-MLQC73I-KFOEPI4-MBMS44D-VWTFFAF-WAWNSQ3";
        pixel-6a.id = "MCGDVOM-VJQ3IHA-HHLCELL-ABFIJT7-BFHHWMX-V77WXIF-OTEVLZH-F76I5Q6";
      };
      folders = {
        "${local-dir}/share" = {
          id = "share";
          devices = ["nix-zenbook" "nix-desktop" "galaxy-s7-tab" "pixel-6a"];
        };
      };
    };
  };
}
