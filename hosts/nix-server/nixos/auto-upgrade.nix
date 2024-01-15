{config, pkgs, ...}: {
  systemd.services.nix-flake-update = {
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
  system.autoUpgrade.dates = "Sun *-*-* 04:20:00";
}
