{
  lib,
  config,
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
    programs.niri = {
      enable = true;
      settings = {
        cursor = {
          theme = "phinger-cursors-light";
          size = 40;
        };
        input = {
          touchpad = {
            accel-speed = 0.6;
            accel-profile = "flat";
          };
          mouse = {
            accel-speed = 0.25;
            accel-profile = "flat";
          };
        };
        layout = {
          background-color = "transparent";
          gaps = 6;
          focus-ring = {
            width = 2;
            active.color = "#${config.lib.stylix.colors.base09}";
            inactive.color = "#${config.lib.stylix.colors.base03}";
          };
        };
        window-rules = [
          {
            geometry-corner-radius =
              let
                r = 10.0;
              in
              {
                top-left = r;
                top-right = r;
                bottom-left = r;
                bottom-right = r;
              };
            clip-to-geometry = true;
          }
        ];
        layer-rules = [
          {
            matches = [ { namespace = "^noctalia-wallpaper*"; } ];
            place-within-backdrop = true;
          }
        ];
        debug.honor-xdg-activation-with-invalid-serial = { };
        binds = {
          "Mod+Return".action.spawn = "kitty";
          "Mod+R".action.spawn-sh = "vicinae toggle";
          "Mod+Shift+Q".action.close-window = { };
        };
        spawn-at-startup = [
          { command = [ "noctalia-shell" ]; }
        ];
        hotkey-overlay.skip-at-startup = true;
        prefer-no-csd = true;
      };
    };
    programs.noctalia-shell.enable = true;
    services.mako.enable = true;
    stylix.targets.qt.platform = "qtct";
  };
}
