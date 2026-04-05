{ ... }:
let
  wall-dir = "/nix/persist/nix-homelab/assets/wallpapers/nix-zenbook";
in
{
  programs.noctalia-shell.settings = {
    idle.enabled = true;
    wallpaper = {
      directory = wall-dir;
      automationEnabled = true;
      randomIntervalSec = 600;
      transitionType = [
        "fade"
        "disc"
        "stripes"
        "wipe"
        "honeycomb"
      ];
    };
  };
  home.file.".cache/noctalia/wallpapers.json".enable = false;
}
