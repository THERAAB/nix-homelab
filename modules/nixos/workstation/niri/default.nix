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
    programs.niri.enable = true;
    services.keyd = {
      enable = true;
      keyboards.default.settings.main = {
        leftalt = "leftmeta";
        leftmeta = "leftalt";
      };
    };
    programs.uwsm = {
      enable = true;
      waylandCompositors.niri = {
        prettyName = "Niri";
        comment = "Niri compositor managed by UWSM";
        binPath = pkgs.writeShellScript "niri" ''
          ${lib.getExe config.programs.niri.package} --session
        '';
      };
    };
    environment = {
      sessionVariables = {
        NIRI_DISABLE_SYSTEM_MANAGER_NOTIFY = "1";
        UWSM_SILENT_START = "2";
      };
      systemPackages = with pkgs; [
        xwayland-satellite # xwayland support
        keyd
      ];
      pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];
    };
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${config.programs.uwsm.package}/bin/uwsm start niri-uwsm.desktop";
          user = "raab";
        };
      };
    };
  };
}
