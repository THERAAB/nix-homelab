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
          gaps = 4;
          focus-ring = {
            width = 1;
            active.color = "#000000";
            inactive.color = "#ffffff";
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
        binds = {
          "Mod+Return".action.spawn = "kitty";
          "Mod+R".action.spawn-sh = "vicinae toggle";
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
