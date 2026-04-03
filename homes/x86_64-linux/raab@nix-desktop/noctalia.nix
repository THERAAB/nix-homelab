{ ... }:
{
  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = "/nix/persist/nix-homelab/assets/wallpapers/nix-desktop/wall.jpeg";
    };
  };
}
