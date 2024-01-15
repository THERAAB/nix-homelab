{
  config,
  pkgs,
  ...
}: {
  systemd = {
    services.nix-flake-update = {
      script = ''
        sleep 10
        dir=/nix/persist/nix-homelab
        nix flake update $dir --commit-lock-file
        su -c "git -C $dir push" raab
      '';
      path = with pkgs; [
        gitMinimal
        config.nix.package.out
        config.programs.ssh.package
        su
        coreutils-full
      ];
    };
    timers.nix-flake-update = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "Sun *-*-* 04:10:00";
        Persistent = "true";
        Unit = "nix-flake-update.service";
      };
    };
  };
  system.autoUpgrade.dates = "Sun *-*-* 04:20:00";
}
