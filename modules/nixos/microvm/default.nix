{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.microvm;
in {
  options.nix-homelab.microvm = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
    hostName = mkOption {
      type = str;
    };
  };
  config = mkIf cfg.enable {
    nix-homelab.microvm = {
      podman.enable = true;
      system.enable = true;
      hardware = {
        enable = true;
        hostName = cfg.hostName;
      };
    };
  };
}
