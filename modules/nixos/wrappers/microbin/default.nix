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
