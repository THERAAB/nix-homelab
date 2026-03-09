{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.bentopdf;
in {
  options.nix-homelab.wrappers.bentopdf = with types; {
    enable = mkEnableOption (lib.mdDoc "BentoPdf");
  };
  config = mkIf cfg.enable {
    services.gatus.settings.endpoints = [
      {
        name = "BentoPdf";
        url = "https://pdf.${properties.network.domain}/";
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
    services.bentopdf = {
      enable = true;
      domain = "pdf.pumpkin.rodeo";
      caddy = {
        enable = true;
        virtualHost = {
          hostName = "pdf.${properties.network.domain}";
          useACMEHost = "${properties.network.domain}";
        };
      };
    };
  };
}
