{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab;
let
  cfg = config.nix-homelab.workstation.gtk;
in
{
  options.nix-homelab.workstation.gtk = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup gtk");
  };
  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4 = {
        extraConfig.gtk-application-prefer-dark-theme = 1;
        theme = config.gtk.theme;
      };
    };
  };
}
