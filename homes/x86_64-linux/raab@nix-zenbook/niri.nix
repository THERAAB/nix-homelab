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
        matches = [
          {
            app-id = "firefox";
            is-floating = false;
          }
        ];
        open-on-workspace = "Browse";
        default-column-width.proportion = 1.0;
        open-focused = true;
      }
      {
        matches = [
          {
            app-id = "Horizon-client";
            is-floating = false;
          }
        ];
        open-on-workspace = "Work";
        default-column-width.proportion = 1.0;
        open-focused = true;
      }
      {
        matches = [
          {
            app-id = "steam";
            is-floating = false;
          }
        ];
        open-on-workspace = "Game";
        default-column-width.proportion = 1.0;
        open-focused = true;
      }
      {
        matches = [
          {
            app-id = "kitty";
            is-floating = false;
          }
        ];
        default-column-width.proportion = 0.5;
      }
    ];
  };
}
