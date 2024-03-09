{pkgs, ...}: let
  port = 1337;
  uid = 62893;
  gid = 62893;
  app-name = "olivetin";
  www-dir = "/var/www/${app-name}";
  scripts-dir = "/var/lib/OliveTin/scripts";
  shellScript = pkgs.callPackage ./script.nix {};
  system-icons-dir = "/nix/persist/nix-homelab/share/assets/icons";
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
  services.olivetin = {
    enable = true;
    settings.actions = [
      {
        title = "Reboot Nix-Hypervisor";
        icon = ''<img src = "customIcons/nixos.png" width = "48px"/>'';
        shell = "sudo /var/lib/olivetin/scripts/commands.sh -r";
        timeout = 20;
      }
      {
        title = "Reboot Micro-Server";
        icon = ''<img src = "customIcons/reboot.png" width = "48px"/>'';
        shell = "sudo /var/lib/olivetin/scripts/commands.sh -m micro-server";
        timeout = 20;
      }
      {
        title = "Reboot Micro-Media";
        icon = ''<img src = "customIcons/jellyfin.png" width = "48px"/>'';
        shell = "sudo /var/lib/olivetin/scripts/commands.sh -m micro-media";
        timeout = 20;
      }
      {
        title = "Reboot Micro-Utils";
        icon = ''<img src = "customIcons/unifi.png" width = "48px"/>'';
        shell = "sudo /var/lib/olivetin/scripts/commands.sh -m micro-utils";
        timeout = 20;
      }
      {
        title = "Reboot Micro-Tailscale";
        icon = ''<img src = "customIcons/tailscale.png" width = "48px"/>'';
        shell = "sudo /var/lib/olivetin/scripts/commands.sh -m micro-tailscale";
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

  networking.firewall.allowedTCPPorts = [port];
}
