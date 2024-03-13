{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.microvm.system;
in {
  options.nix-homelab.microvm.system = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
    environment = {
      variables.TERM = "xterm-256color";
      noXlibs = false;
      systemPackages = with pkgs; [
        fuse-overlayfs
      ];
    };
    users.allowNoPasswordLogin = true;
    security.sudo.execWheelOnly = true;
  };
}
