{
  properties,
  pkgs,
  ...
}: let
  port = properties.ports.olivetin;
  scripts-dir = "/var/lib/olivetin/scripts";
  shellScript = pkgs.callPackage ./script.nix {};
in {
  systemd.tmpfiles.rules = [
    "r  ${scripts-dir}/commands.sh    -           -               -               -   -                                     "
    "L  ${scripts-dir}/commands.sh    -           -               -               -   ${shellScript}                        "
    "Z  ${scripts-dir}                500         root            root            -   -                                     "
  ];
  services.caddy.virtualHosts = {
    "olivetin.${properties.network.domain}" = {
      useACMEHost = "${properties.network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString properties.ports.olivetin}
      '';
    };
  };
  services.gatus.settings.endpoints = [
    {
      name = "Olivetin";
      url = "https://olivetin.${properties.network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>OliveTin</title>*)''
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
  ];
  services.olivetin = {
    enable = true;
    settings = {
      ListenAddressSingleHTTPFrontend = "0.0.0.0:${toString port}";
      actions = [
        {
          title = "Reboot Nix-Hypervisor";
          icon = ''<iconify-icon icon="devicon:nixos"></iconify-icon>'';
          shell = "/run/wrappers/bin/sudo ${scripts-dir}/commands.sh -r";
          timeout = 20;
        }
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [port];
}
