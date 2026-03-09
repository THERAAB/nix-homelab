{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.homer;
  network = properties.network;
in {
  options.nix-homelab.wrappers.homer = with types; {
    enable = mkEnableOption (lib.mdDoc "Homer");
  };
  config = mkIf cfg.enable {
    services = {
      caddy.virtualHosts = {
        "${properties.network.domain}" = {
          useACMEHost = "${properties.network.domain}-tld";
        };
      };
      gatus.settings.endpoints = [
        {
          name = "Homer";
          url = "https://${properties.network.domain}/";
          conditions = [
            "[STATUS] == 200"
            ''[BODY] == pat(*<div id="app-mount"></div>*)''
          ];
          alerts = [
            {
              type = "gotify";
            }
          ];
        }
      ];
      homer = {
        enable = true;
        virtualHost = {
          caddy.enable = true;
          domain = network.domain;
        };
      };
    };
  };
}
