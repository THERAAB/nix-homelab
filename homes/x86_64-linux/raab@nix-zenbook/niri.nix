{ ... }:
{
  programs.niri.settings = {
    spawn-at-startup = [
      {
        sh = "systemctl --user restart libinput-gestures.service";
      }
    ];
    window-rules = [
      {
        matches = [ { app-id = "firefox"; } ];
        open-on-workspace = "Browse";
        default-column-width.proportion = 1.0;
        open-focused = true;
      }
      {
        matches = [ { app-id = "Horizon-client"; } ];
        open-on-workspace = "Work";
        default-column-width.proportion = 1.0;
        open-focused = true;
      }
      {
        matches = [ { app-id = "steam"; } ];
        open-on-workspace = "Game";
        default-column-width.proportion = 1.0;
        open-focused = true;
      }
      {
        matches = [ { app-id = "kitty"; } ];
        default-column-width.proportion = 0.5;
      }
    ];
  };
}
