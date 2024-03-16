{
  lib,
  pkgs,
  ...
}: {
  systemd.services = {
    nix-flake-update = {
      script = ''
        sleep 10
        dir=/nix/persist/nix-homelab
        su -c "git -C $dir pull" raab
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
        OnCalendar = lib.mkDefault "Sun *-*-* 04:40:00";
        Persistent = "true";
        Unit = "nix-flake-update.service";
      };
    };
  };
}
