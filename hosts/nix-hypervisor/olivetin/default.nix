{pkgs, ...}: let
  port = 1337;
  uid = 62893;
  gid = 62893;
  app-name = "olivetin";
  www-dir = "/var/www/${app-name}";
  scripts-dir = "/var/lib/${app-name}/scripts";
  shellScript = pkgs.callPackage ./script.nix {};
  system-icons-dir = "/nix/persist/nix-homelab/share/assets/icons";
  network = import ../../../share/network.properties.nix;
in {
  systemd.tmpfiles.rules = [
    "R  ${www-dir}                    -           -               -               -   -                         "
    "C  ${www-dir}                    -           -               -               -   ${pkgs.olivetin}/www      "
    "r  ${scripts-dir}/commands.sh    -           -               -               -   -                         "
    "L  ${scripts-dir}/commands.sh    -           -               -               -   ${shellScript}            "
    "R  ${www-dir}/customIcons        -           -               -               -   -                         "
    "C  ${www-dir}/customIcons        -           -               -               -   ${system-icons-dir}       "
    "Z  ${scripts-dir}                500         root            root            -   -                         "
    "Z  ${www-dir}                    -           ${app-name}     ${app-name}     -   -                         "
  ];
  services = {
    caddy.virtualHosts."${app-name}.${network.domain}" = {
      useACMEHost = "${network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
    olivetin = {
      enable = true;
      settings.actions = [
        {
          title = "Reboot Server";
          icon = ''<img src = "customIcons/reboot.png" width = "48px"/>'';
          shell = "sudo /var/lib/olivetin/scripts/commands.sh -r";
          timeout = 20;
        }
        {
          title = "Reboot Micro-Server";
          icon = ''<img src = "customIcons/nixos.png" width = "48px"/>'';
          shell = "sudo /var/lib/olivetin/scripts/commands.sh -m micro-server";
          timeout = 20;
        }
        {
          title = "Reboot Micro-Media";
          icon = ''<img src = "customIcons/jellyfin.png" width = "48px"/>'';
          shell = "sudo /var/lib/olivetin/scripts/commands.sh -m micro-media";
          timeout = 20;
        }
      ];
    };
  };
  users = {
    groups.${app-name}.gid = gid;
    users.${app-name} = {
      group = app-name;
      uid = uid;
      isSystemUser = true;
    };
  };

  networking.firewall.allowedTCPPorts = [port];
}