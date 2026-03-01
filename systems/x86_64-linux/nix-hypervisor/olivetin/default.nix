{
  self,
  properties,
  pkgs,
  ...
}: let
  port = properties.ports.olivetin;
  uid = 62893;
  gid = 62893;
  app-name = "olivetin";
  www-dir = "/var/www/${app-name}";
  scripts-dir = "/var/lib/olivetin/scripts";
  shellScript = pkgs.callPackage ./script.nix {};
  system-icons-dir = self + "/assets/icons";
in {
  systemd.tmpfiles.rules = [
    "R  ${www-dir}                    -           -               -               -   -                                     "
    "C  ${www-dir}                    -           -               -               -   ${pkgs.nix-homelab.olivetin}/www      "
    "r  ${scripts-dir}/commands.sh    -           -               -               -   -                                     "
    "L  ${scripts-dir}/commands.sh    -           -               -               -   ${shellScript}                        "
    "R  ${www-dir}/customIcons        -           -               -               -   -                                     "
    "C  ${www-dir}/customIcons        -           -               -               -   ${system-icons-dir}                   "
    "Z  ${scripts-dir}                500         root            root            -   -                                     "
    "Z  ${www-dir}                    -           ${app-name}     ${app-name}     -   -                                     "
  ];
  nix-homelab.services.olivetin = {
    enable = true;
    settings.actions = [
      {
        title = "Reboot Nix-Hypervisor";
        icon = ''<img src = "customIcons/nixos.png" width = "48px"/>'';
        shell = "sudo /var/lib/olivetin/scripts/commands.sh -r";
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
