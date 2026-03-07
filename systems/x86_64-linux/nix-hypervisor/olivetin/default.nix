{
  self,
  properties,
  pkgs,
  ...
}: let
  port = properties.ports.olivetin;
  app-name = "olivetin";
  www-dir = "/var/www/${app-name}";
  scripts-dir = "/var/lib/olivetin/scripts";
  shellScript = pkgs.callPackage ./script.nix {};
  system-icons-dir = self + "/assets/icons";
in {
  systemd.tmpfiles.rules = [
    "R  ${www-dir}                    -           -               -               -   -                                     "
    "C  ${www-dir}                    -           -               -               -   ${pkgs.olivetin}/www      "
    "r  ${scripts-dir}/commands.sh    -           -               -               -   -                                     "
    "L  ${scripts-dir}/commands.sh    -           -               -               -   ${shellScript}                        "
    "R  ${www-dir}/customIcons        -           -               -               -   -                                     "
    "C  ${www-dir}/customIcons        -           -               -               -   ${system-icons-dir}                   "
    "Z  ${scripts-dir}                500         root            root            -   -                                     "
    "Z  ${www-dir}                    -           ${app-name}     ${app-name}     -   -                                     "
  ];
  services.olivetin = {
    enable = true;
    settings = {
      ListenAddressSingleHTTPFrontend = "0.0.0.0:${toString port}";
      actions = [
        {
          title = "Reboot Nix-Hypervisor";
          icon = ''<img src = "customIcons/reboot.png" width = "48px"/>'';
          shell = "/run/wrappers/bin/sudo /var/lib/olivetin/scripts/commands.sh -r";
          timeout = 20;
        }
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [port];
}
