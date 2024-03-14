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
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [port];
    services.${app-name} = {
      enable = true;
      port = port;
    };
  };
}
