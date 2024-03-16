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
        boot.enable = true;
        auto-upgrade.enable = true;
        configuration.enable = true;
        plymouth.enable = true;
        fish.enable = true;
        gnome.enable = true;
        hardware.enable = true;
        starship.enable = true;
        syncthing.enable = true;
        system.enable = true;
        users.enable = true;
        hardware-configuration.enable = true;
      };
      utils.nox.enable = true;
    };
    programs.firefox.enable = true;
  };
}
