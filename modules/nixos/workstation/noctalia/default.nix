{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab;
let
  cfg = config.nix-homelab.workstation.noctalia;
in
{
  options.nix-homelab.workstation.noctalia = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup noctalia");
  };
  config = mkIf cfg.enable {
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
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
        TERM = "kitty";
      };
    };
  };
}
