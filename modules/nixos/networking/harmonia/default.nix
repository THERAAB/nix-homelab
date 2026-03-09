{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.networking.harmonia;
in {
  options.nix-homelab.networking.harmonia = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup network fileshare permissions");
  };
  config = mkIf cfg.enable {
    services.gatus.settings.endpoints = [
      {
        name = "Harmonia Cache";
        url = "https://cache.${properties.network.domain}/";
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<title>*harmonia*</title>*)''
        ];
        alerts = [
          {
            type = "gotify";
          }
        ];
      }
    ];
    services.caddy.virtualHosts = {
      "cache.${properties.network.domain}" = {
        useACMEHost = "${properties.network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString properties.ports.harmonia}
        '';
      };
    };
    services.harmonia = {
      enable = true;
      signKeyPaths = [config.sops.secrets.harmonia_secret.path];
    };
    nix.settings.allowed-users = ["harmonia"];
  };
}
