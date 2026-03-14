{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.miniflux;
in {
  options.nix-homelab.wrappers.miniflux = with types; {
    enable = mkEnableOption (lib.mdDoc "Miniflux");
  };
  config = mkIf cfg.enable {
    services.caddy.virtualHosts = {
      "rss.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString properties.ports.miniflux}
        '';
      };
    };
    services.gatus.settings.endpoints = [
      {
        name = "Miniflux";
        url = "https://rss.${properties.network.domain}/";
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
    services.miniflux = {
      enable = true;
      config.LISTEN_ADDR = "0.0.0.0:${toString properties.ports.miniflux}";
      adminCredentialsFile = config.sops.secrets.miniflux_admin.path;
    };
  };
}
