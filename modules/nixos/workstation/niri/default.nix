{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab;
let
  cfg = config.nix-homelab.workstation.niri;
in
{
  options.nix-homelab.workstation.niri = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup niri");
  };
  config = mkIf cfg.enable {
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
    programs.niri.enable = true;
    services = {
      xserver.enable = true;
      gnome.gnome-keyring.enable = lib.mkForce false;
    };
    programs.kdeconnect.enable = true;
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        XDG_SESSION_TYPE = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        GDK_BACKEND = "wayland";
        QS_ICON_THEME = "Papirus-Dark";
      };
      systemPackages = with pkgs; [
        xwayland-satellite # xwayland support
      ];
    };
    environment.pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${config.programs.niri.package}/bin/niri-session";
          user = "raab";
        };
      };
    };
  };
}
