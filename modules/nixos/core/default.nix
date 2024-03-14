{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.core;
in {
  options.nix-homelab.core = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
    nix-homelab.core = {
      flakes.enable = true;
      system.enable = true;
    };
  };
}
