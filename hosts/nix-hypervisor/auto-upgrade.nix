{...}: {
  systemd.timers.nix-flake-update.timerConfig.OnCalendar = "Sun *-*-* 04:20:00";
  system.autoUpgrade.dates = "Sun *-*-* 04:30:00";
}
