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
    nix-homelab.workstation = {
      ulauncher.enable = true;
      git.enable = true;
      dconf.enable = true;
      firefox.enable = true;
      fish.enable = true;
      gnome.enable = true;
      gtk.enable = true;
      home.enable = true;
      kitty.enable = true;
      nvim.enable = true;
      vscode.enable = true;
      persist.enable = true;
    };
  };
}
