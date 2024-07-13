{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.gtk;
in {
  options.nix-homelab.workstation.gtk = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup gtk");
  };
  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name = "catppuccin-frappe-blue-standard";
        package = pkgs.catppuccin-gtk;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      font = {
        name = "NotoSans Nerd Font";
      };
      cursorTheme = {
        name = "phinger-cursors-light";
        package = pkgs.phinger-cursors;
        size = 40;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };
    home.sessionVariables = {
      GTK_THEME = "catppuccin-frappe-blue-standard";
      XCURSOR_THEME = "phinger-cursors-light";
      XCURSOR_SIZE = 40;
    };

    home.packages = with pkgs; [
      catppuccin-gtk
    ];
  };
}
