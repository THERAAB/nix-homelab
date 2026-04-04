{ pkgs, ... }:
{
  programs.niri.settings = {
    outputs."DP-1".mode = {
      refresh = 100.000;
      height = 1440;
      width = 3440;
    };
    binds = {
      "Mod+Shift+H".action.spawn-sh =
        "${pkgs.pulseaudio}/bin/pactl set-default-sink alsa_output.usb-Fractal_Fractal_Scape_Dongle_00000000911AD5811398-00.iec958-stereo";
      "Mod+Shift+K".action.spawn-sh =
        "${pkgs.pulseaudio}/bin/pactl set-default-sink alsa_output.pci-0000_1b_00.6.iec958-stereo";
    };
    window-rules = [
      {
        matches = [
          {
            app-id = "firefox";
            is-floating = false;
          }
        ];
        open-on-workspace = "Browse";
        default-column-width.proportion = 0.75;
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
        default-column-width.proportion = 0.75;
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
        default-column-width.proportion = 0.3;
      }
      {
        matches = [
          {
            app-id = "dev.zed.Zed";
            is-floating = false;
          }
        ];
        default-column-width.proportion = 0.5;
      }
    ];
  };
}
