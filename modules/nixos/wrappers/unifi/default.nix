{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.unifi;
  port = properties.ports.unifi;
in {
  options.nix-homelab.wrappers.unifi = with types; {
    enable = mkEnableOption (lib.mdDoc "Unifi");
  };
  config = mkIf cfg.enable {
    services.unifi = {
      enable = true;
      openFirewall = true;
      unifiPackage = pkgs.unifi;
      mongodbPackage = pkgs.mongodb-7_0;
    };
    networking.firewall.allowedTCPPorts = port;
  };
}
