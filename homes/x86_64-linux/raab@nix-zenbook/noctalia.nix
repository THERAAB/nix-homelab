{ pkgs, ... }:
let
  wall-dir = "/nix/persist/nix-homelab/assets/wallpapers/nix-zenbook";
in
{
  programs.noctalia-shell.settings.idle.enabled = false;
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
            /etc/profiles/per-user/raab/bin/noctalia-shell ipc call wallpaper set $wallpaper
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
  home.file.".cache/noctalia/wallpapers.json".enable = false;
}
