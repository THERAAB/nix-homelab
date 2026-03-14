{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.microbin;
  port = properties.ports.microbin;
in {
  options.nix-homelab.wrappers.microbin = with types; {
    enable = mkEnableOption (lib.mdDoc "Microbin");
  };
  config = mkIf cfg.enable {
    services.caddy.virtualHosts = {
      "microbin.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString properties.ports.microbin}
        '';
      };
    };
    services.gatus.settings.endpoints = [
      {
        name = "Microbin";
        url = "https://microbin.${properties.network.domain}/";
        conditions = [
          "[STATUS] == 200"
        ];
        alerts = [
          {
            type = "gotify";
          }
        ];
      }
    ];
    networking.firewall.allowedTCPPorts = [port];
    services.microbin = {
      enable = true;
      passwordFile = "/run/secrets/df_password";
      settings = {
        MICROBIN_PORT = port;
      };
    };
  };
}
