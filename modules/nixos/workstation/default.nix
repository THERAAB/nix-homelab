{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation;
in {
  options.nix-homelab.workstation = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup workstation");
  };
  config = mkIf cfg.enable {
    nix-homelab = {
      workstation = {
        auto-upgrade.enable = true;
        configuration.enable = true;
        plymouth.enable = true;
        gnome.enable = true;
        hardware.enable = true;
        syncthing.enable = true;
        system.enable = true;
        hardware-configuration.enable = true;
      };
      physical.enable = true;
    };
    programs.firefox.enable = true;
  };
}
