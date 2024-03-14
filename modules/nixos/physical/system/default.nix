{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.physical.system;
in {
  options.nix-homelab.physical.system = with types; {
    enable = mkEnableOption (lib.mdDoc "System for physical machines");
  };
  config = mkIf cfg.enable {
    security.auditd.enable = true;
    services = {
      tailscale = {
        enable = true;
        extraUpFlags = ["--ssh"];
      };
      locate = {
        enable = true;
        package = pkgs.plocate;
        localuser = null;
      };
    };
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };
  };
}
