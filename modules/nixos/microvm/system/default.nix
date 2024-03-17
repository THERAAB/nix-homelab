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
    enable = mkEnableOption (lib.mdDoc "System setup for microvms");
    hostName = mkOption {
      type = str;
    };
  };
  config = mkIf cfg.enable {
    environment = {
      etc."machine-id" = {
        mode = "0644";
        text = properties.network.${cfg.hostName}.machine-id + "\n";
      };
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
