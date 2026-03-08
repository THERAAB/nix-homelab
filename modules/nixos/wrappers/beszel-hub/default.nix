{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.beszel-hub;
  port = properties.ports.beszel;
in {
  options.nix-homelab.wrappers.beszel-hub = with types; {
    enable = mkEnableOption (lib.mdDoc "Beszel hub");
  };
  config = mkIf cfg.enable {
    # TODO: notifications
    services.beszel.hub = {
      enable = true;
      port = port;
      host = "0.0.0.0";
    };
  };
}
