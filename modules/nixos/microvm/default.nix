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
    enable = mkEnableOption (lib.mdDoc "Default microvm setup");
    hostName = mkOption {
      type = str;
      default = config.networking.hostName;
    };
  };
  config = mkIf cfg.enable {
    nix-homelab = {
      core.enable = true;
      microvm = {
        podman.enable = true;
        system = {
          enable = true;
          hostName = cfg.hostName;
        };
      };
    };
  };
}
