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
