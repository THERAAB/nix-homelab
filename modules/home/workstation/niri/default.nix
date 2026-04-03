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
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = [
          "gtk"
          "gnome"
        ];
        niri.default = [
          "gtk"
          "gnome"
        ];
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
    };
    programs.vicinae.extensions = [
      (config.lib.vicinae.mkExtension {
        name = "niri";
        src =
          pkgs.fetchFromGitHub {
            owner = "vicinaehq";
            repo = "extensions";
            rev = "50233dff9dfc70fc6b39c2387687e5661b09f005";
            sha256 = "sha256-GVIbXYiA506LV0cEsG1AA4vTwDJq9R6v6lFFs8z7knY=";
          }
          + "/extensions/niri";
      })
    ];
    programs.niri = {
      enable = true;
      settings = {
        overview.backdrop-color = "#${config.lib.stylix.colors.base00}";
        cursor = {
          theme = "phinger-cursors-light";
          size = 40;
          hide-when-typing = true;
        };
        input = {
          touchpad = {
            accel-speed = 0.6;
            accel-profile = "flat";
            dwt = true;
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
          { draw-border-with-background = false; }
        ];
        workspaces = {
          "2".name = "Game";
          "1".name = "Work";
          "0".name = "Browse";
        };
        layout.always-center-single-column = true;
        layer-rules = [
          {
            matches = [ { namespace = "^noctalia-wallpaper*"; } ];
            place-within-backdrop = true;
          }
        ];
        debug.honor-xdg-activation-with-invalid-serial = { };
        binds = {
          "Mod+O".action.toggle-overview = { };
          "Mod+Return".action.spawn = "kitty";
          "Mod+R".action.spawn-sh = "vicinae toggle";
          "Mod+Shift+Q".action.close-window = { };
          "Mod+f".action.toggle-window-floating = { };
          "Mod+Ctrl+f".action.switch-focus-between-floating-and-tiling = { };
          "Mod+Space".action.fullscreen-window = { };
          "Mod+Escape".action.toggle-keyboard-shortcuts-inhibit = { };
          "Mod+Left".action.focus-column-left = { };
          "Mod+Right".action.focus-column-right = { };
          "Mod+Up".action.focus-window-or-workspace-up = { };
          "Mod+Down".action.focus-window-or-workspace-down = { };
          "Mod+Shift+Left".action.move-column-left = { };
          "Mod+Shift+Right".action.move-column-right = { };
          "Mod+Shift+Up".action.move-column-to-workspace-up = { };
          "Mod+Shift+Down".action.move-column-to-workspace-down = { };
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+Ctrl+1" = {
            action.set-column-width = "100%";
            allow-inhibiting = false;
          };
          "Mod+Ctrl+2" = {
            action.set-column-width = "70%";
            allow-inhibiting = false;
          };
          "Mod+Ctrl+3" = {
            action.set-column-width = "50%";
            allow-inhibiting = false;
          };
          "Mod+Ctrl+4" = {
            action.set-column-width = "30%";
            allow-inhibiting = false;
          };
          "Mod+Ctrl+Left" = {
            action.spawn-sh = "niri msg action set-column-width -10%";
            allow-inhibiting = false;
          };
          "Mod+Ctrl+Right" = {
            action.spawn-sh = "niri msg action set-column-width +10%";
            allow-inhibiting = false;
          };
          "Mod+Ctrl+Up" = {
            action.spawn-sh = "niri msg action set-column-height +10%";
            allow-inhibiting = false;
          };
          "Mod+Ctrl+Down" = {
            action.spawn-sh = "niri msg action set-column-height -10%";
            allow-inhibiting = false;
          };
          "Mod+Shift+1".action.move-window-to-workspace = [
            { focus = true; }
            "Browse"
          ];
          "Mod+Shift+2".action.move-window-to-workspace = [
            { focus = true; }
            "Work"
          ];
          "Mod+Shift+3".action.move-window-to-workspace = [
            { focus = true; }
            "Game"
          ];
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
        prefer-no-csd = false;
      };
    };
  };
}
