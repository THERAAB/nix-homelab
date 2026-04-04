{
  lib,
  config,
  properties,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab;
let
  cfg = config.nix-homelab.wrappers.olivetin;
  port = properties.ports.olivetin;
  scripts-dir = "/var/lib/olivetin/scripts";
  shellScript = pkgs.callPackage ./script.nix { };
in
{
  options.nix-homelab.wrappers.olivetin = with types; {
    enable = mkEnableOption (lib.mdDoc "Olivetin");
  };
  config = mkIf cfg.enable {
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
          "[BODY] == pat(*<title>OliveTin</title>*)"
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
      package = pkgs.olivetin-3k;
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
    networking.firewall.allowedTCPPorts = [ port ];
  };
}
