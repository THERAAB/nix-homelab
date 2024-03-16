{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.auto-upgrade;
in {
  options.nix-homelab.workstation.auto-upgrade = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup auto-upgrade");
  };
  config = mkIf cfg.enable {
    system.autoUpgrade = {
      randomizedDelaySec = "45min";
      operation = "boot";
      allowReboot = false;
    };
  };
}
