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
        ulauncher.enable = true;
        dconf.enable = true;
        firefox.enable = true;
        gnome.enable = true;
        gtk.enable = true;
        pkgs.enable = true;
        kitty.enable = true;
        vscode.enable = true;
        persist.enable = true;
      };
      physical.enable = true;
    };
  };
}
