{ ... }:
{
  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = "/nix/persist/nix-homelab/assets/wallpapers/nix-zenbook/wall.jpg";
    };
  };
  programs.niri.settings.window-rules = [
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
}
