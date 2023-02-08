{ config, pkgs, ... }:
let
  port = 1337;
  uid = 62893;
  gid = 62893;
  app-name = "olivetin";
  www-dir = "/var/www/${app-name}";
  scripts-dir = "/nix/persist/${app-name}/scripts";
  shellScript = pkgs.callPackage ./script.nix {};
  system-icons-dir = "/nix/persist/nix-homelab/assets/icons";
in
{
  services.yamlConfigMaker.gatus.settings.endpoints = [
    {
      name = "OliveTin";
      url = "http://${app-name}.server.box/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>OliveTin</title>*)''
      ];
      alerts = [
        {
          type = "custom";
        }
      ];
    }
  ];
  services.olivetin = {
    enable = true;
    settings.actions = [
      {
        title = "Reboot Server";
        icon = ''<img src = "customIcons/reboot.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -r";
        timeout = 20;
      }
    ];
  };
  users = {
    groups.${app-name}.gid = gid;
    users.${app-name} = {
      group = app-name;
      uid = uid;
      isSystemUser = true;
    };
  };

  systemd.tmpfiles.rules = [
    "R  ${www-dir}                    -           -               -               -   -                         "
    "C  ${www-dir}                    -           -               -               -   ${pkgs.olivetin}/www      "
    "r  ${scripts-dir}/commands.sh    -           -               -               -   -                         "
    "L  ${scripts-dir}/commands.sh    -           -               -               -   ${shellScript}            "
    "r  ${www-dir}/customIcons        -           -               -               -   -                         "
    "L  ${www-dir}/customIcons        -           -               -               -   ${system-icons-dir}       "
    "Z  ${scripts-dir}                700         root            root            -   -                         "
    "Z  ${www-dir}                    770         ${app-name}     ${app-name}     -   -                         "
  ];
  networking.firewall.allowedTCPPorts = [ port ];
  services.caddy.virtualHosts = {
    "http://${app-name}.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
}