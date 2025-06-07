{pkgs, ...}: let
  wall-dir = "/nix/persist/nix-homelab/assets/wallpapers/nix-zenbook";
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
  # TODO: 4 finger gestures
  dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      speed = 0.19298245614035081;
    };
    "org/gnome/shell" = {
      last-selected-power-profile = "power-saver";
    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "suspend";
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      static-blur = true;
    };
    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };
    "org/gnome/shell/extensions/just-perfection" = {
      panel-in-overview = true;
      panel = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur = false; #TODO: put back to true when panel-in-overview works with blur my shell again
    };
  };
}
