{...}: {
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "file:///nix/persist/nix-homelab/assets/wallpapers/desktop/wall.jpg";
      picture-uri-dark = "file:///nix/persist/nix-homelab/assets/wallpapers/desktop/wall.jpg";
    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      static-blur = false;
    };
  };
}
