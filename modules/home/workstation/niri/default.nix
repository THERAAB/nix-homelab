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
          size = 48;
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
          };
        };
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
    stylix.targets.qt.platform = "qtct";
  };
}
