{ config, pkgs, ... }:
let
  port = 19999;
  app-name = "netdata";
in
{
  imports = [ ../modules/nixos/olivetin ];
  services.olivetin.settings.actions = [
    {
      title = "Restart NetData";
      icon = ''<img src = "customIcons/netdata.png" width = "48px"/>'';
      shell = "sudo /nix/persist/olivetin/scripts/commands.sh -s netdata";
      timeout = 20;
    }
  ];
  services.caddy.virtualHosts = {
    "http://${app-name}.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
  networking.firewall.allowedTCPPorts = [ port ];
  services.netdata = {
    enable = true;
    configText = ''
      [global]
        update every = 5
      [ml]
        enabled = no
      [logs]
        debug log = none
        error log = none
        access log = none
    '';
  };
}