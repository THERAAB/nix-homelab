{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.immich;
  port = properties.ports.immich;
in {
  options.nix-homelab.wrappers.immich = with types; {
    enable = mkEnableOption (lib.mdDoc "Immich");
  };
  config = mkIf cfg.enable {
    services.immich = {
      enable = true;
      port = port;
      host = "0.0.0.0";
      openFirewall = true;
      accelerationDevices = ["/dev/dri/renderD128"];
    };
    users.users.immich.extraGroups = ["video" "render"];
  };
}
