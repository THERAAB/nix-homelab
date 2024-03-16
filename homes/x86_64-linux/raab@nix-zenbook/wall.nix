{pkgs, ...}: let
  wall-dir = "/nix/persist/nix-homelab/systems/x86_64-linux/nix-zenbook/assets/wall/";
in {
  systemd.user = {
    services.wallpaper-rotate = {
      Install.WantedBy = ["basic.target"];
      Service = {
        Type = "simple";
        ExecStart = toString (pkgs.writeShellScript "wallpaper-rotate" ''
          #!/bin/sh
          wallpaper=`${pkgs.findutils}/bin/find ${wall-dir} -type f | ${pkgs.coreutils-full}/bin/shuf -n1`
          ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/background/picture-uri "'file://$wallpaper'"
          ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/background/picture-uri-dark "'file://$wallpaper'"
        '');
        Environment = "DISPLAY=:0";
      };
    };
    timers.wallpaper-rotate = {
      Timer = {
        Unit = "wallpaper-rotate.service";
        OnCalendar = "*:0/30"; # Every 30 minutes
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
