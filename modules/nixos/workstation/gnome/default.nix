{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.gnome;
in {
  options.nix-homelab.workstation.gnome = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup gnome");
  };
  config = mkIf cfg.enable {
    services = {
      displayManager.autoLogin = {
        enable = true;
        user = "raab";
      };
      xserver = {
        enable = true;
        displayManager = {
          gdm.enable = true;
        };
        desktopManager.gnome.enable = true;
      };
      gnome.gnome-keyring.enable = lib.mkForce false;
    };
    environment = {
      gnome.excludePackages =
        (with pkgs; [
          gnome-photos
          gnome-tour
        ])
        ++ (with pkgs; [
          gnome-music
          epiphany # web browser
          geary # email reader
          gnome-characters
          tali # poker game
          iagno # go game
          hitori # sudoku game
          atomix # puzzle game
          yelp # Help view
          gnome-contacts
          gnome-initial-setup
          gnome-maps
        ]);
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland-egl";
      };
    };
    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
