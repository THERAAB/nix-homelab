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
            width = 0;
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
          "Mod+f".action.toggle-window-floating = { };
          "Mod+Ctrl+f".action.switch-focus-between-floating-and-tiling = { };
          "Mod+Space".action.fullscreen-window = { };
          "Mod+Left".action.focus-column-left = { };
          "Mod+Right".action.focus-column-right = { };
          "Mod+Up".action.focus-window-or-workspace-up = { };
          "Mod+Down".action.focus-window-or-workspace-down = { };
          "Mod+Shift+Left".action.move-column-left = { };
          "Mod+Shift+Right".action.move-column-right = { };
          "Mod+Shift+Up".action.move-window-up = { };
          "Mod+Shift+Down".action.move-window-down = { };
          "XF86AudioRaiseVolume".action.spawn-sh = "noctalia-shell ipc call volume increase";
          "XF86AudioLowerVolume".action.spawn-sh = "noctalia-shell ipc call volume decrease";
          "XF86AudioMute".action.spawn-sh = "noctalia-shell ipc call volume muteOutput";
          "XF86MonBrightnessUp".action.spawn-sh = "noctalia-shell ipc call brightness increase";
          "XF86MonBrightnessDown".action.spawn-sh = "noctalia-shell ipc call brightness decrease";
        };
        spawn-at-startup = [
          { command = [ "noctalia-shell" ]; }
        ];
        hotkey-overlay.skip-at-startup = true;
        prefer-no-csd = true;
      };
    };
    programs.noctalia-shell = {
      enable = true;
      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          kde-connect = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
        version = 1;
      };
      settings = {
        notifications.enabled = true;
        ui.panelBackgroundOpacity = lib.mkForce 0.96;
        bar = {
          backgroundOpacity = lib.mkForce 0.96;
          outerCorners = false;
          # displayMode = "auto_hide";
        };
        general = {
          showChangelogOnStartup = false;
          telemetryEnabled = false;
        };
        dock.enabled = false;
        location = {
          name = "New York, New York";
          weatherShowEffects = true;
          useFahrenheit = true;
          use12hourFormat = true;
        };
        nightLight = {
          enabled = true;
          autoSchedule = true;
          nightTemp = "4000";
          dayTemp = "6500";
        };
      };
    };
    services.mako.enable = true;
    stylix.targets.qt.platform = "qtct";
  };
}
