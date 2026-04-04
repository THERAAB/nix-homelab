{ ... }:
let
  wall-dir = "/nix/persist/nix-homelab/assets/wallpapers/nix-zenbook";
in
{
  programs.noctalia-shell.settings = {
    idle.enabled = true;
    wallpaper.directory = wall-dir;
  };
  home.file.".cache/noctalia/wallpapers.json".enable = false;
}
