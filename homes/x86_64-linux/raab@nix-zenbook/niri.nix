{ pkgs, ... }:
let
  wall-dir = "/nix/persist/nix-homelab/assets/wallpapers/nix-zenbook";
in
{
  systemd.user = {
    services.wallpaper-rotate = {
      Unit = {
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        Requisite = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = toString (
          pkgs.writeShellScript "wallpaper-rotate" ''
            #!/bin/sh
            wallpaper=`${pkgs.findutils}/bin/find ${wall-dir} -type f | ${pkgs.coreutils-full}/bin/shuf -n1`
            ${pkgs.noctalia-shell}/bin/noctalia-shell ipc call wallpaper set $wallpaper
          ''
        );
        Environment = "DISPLAY=:0";
      };
    };
    timers.wallpaper-rotate = {
      Timer = {
        Unit = "wallpaper-rotate.service";
        OnCalendar = "*:0/30"; # Every 30 minutes
      };
      Install.WantedBy = [ "timers.target" ];
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
