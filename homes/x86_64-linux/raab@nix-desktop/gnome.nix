{...}: let
  background = "file:///nix/persist/nix-homelab/assets/wallpapers/nix-desktop/wall.jpg";
in {
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = background;
      picture-uri-dark = background;
    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      static-blur = false;
    };
  };
}
