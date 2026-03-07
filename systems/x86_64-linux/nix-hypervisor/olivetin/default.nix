{
  self,
  properties,
  pkgs,
  ...
}: let
  port = properties.ports.olivetin;
  app-name = "olivetin";
  icons-dir = "/var/lib/${app-name}/customIcons";
  scripts-dir = "/var/lib/olivetin/scripts";
  shellScript = pkgs.callPackage ./script.nix {};
  system-icons-dir = self + "/assets/icons";
in {
  systemd.tmpfiles.rules = [
    "r  ${scripts-dir}/commands.sh    -           -               -               -   -                                     "
    "L  ${scripts-dir}/commands.sh    -           -               -               -   ${shellScript}                        "
    "R  ${icons-dir}                  -           -               -               -   -                                     "
    "C  ${icons-dir}                 -           -               -               -   ${system-icons-dir}                   "
    "Z  ${scripts-dir}                500         root            root            -   -                                     "
    "Z  ${icons-dir}                  -           olivetin        olivetin        -   -                                     "
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
