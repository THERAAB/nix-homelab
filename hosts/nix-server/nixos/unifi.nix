{pkgs, ...}: let
  port = 8443;
  app-name = "unifi";
  network = import ../../../share/network.properties.nix;
in {
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "Unifi Controller";
      url = "https://${app-name}.${network.domain}:${toString port}";
      conditions = [
        "[STATUS] == 200"
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
      title = "Restart Unifi";
      icon = ''<img src = "customIcons/unifi.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -s ${app-name}";
      timeout = 20;
    }
  ];
  services.caddy.virtualHosts."${app-name}.${network.domain}" = {
    useACMEHost = "${network.domain}";
    extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port} {
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';
  };
  networking.firewall.allowedTCPPorts = [port];
  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi;
  };
}
