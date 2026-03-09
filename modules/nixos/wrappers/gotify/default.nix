{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.gotify;
  port = properties.ports.gotify;
  app-name = "gotify";
in {
  options.nix-homelab.wrappers.gotify = with types; {
    enable = mkEnableOption (lib.mdDoc "Gotify");
  };
  config = mkIf cfg.enable {
    services.gatus.settings.endpoints = [
      {
        name = "Gotify";
        url = "https://gotify.${properties.network.domain}/";
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
    services.caddy.virtualHosts = {
      "gotify.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString properties.ports.gotify}
        '';
      };
    };
    networking.firewall.allowedTCPPorts = [port];
    services.${app-name} = {
      enable = true;
      environment.GOTIFY_SERVER_PORT = port;
    };
  };
}
