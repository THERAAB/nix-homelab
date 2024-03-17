{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.utils.nox;
in {
  options.nix-homelab.utils.nox = with types; {
    enable = mkEnableOption (lib.mdDoc "Nox for executing common nixos tasks");
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      (
        pkgs.writeScriptBin "nox" ''

          #!/bin/sh
          # nox: NixOs eXecute

          dir=/nix/persist/nix-homelab
          git=${pkgs.git}/bin/git

          inputs() {
              $git -C $dir pull
              sudo nix flake update $dir
          }
          rebuild() {
              $git -C $dir pull
              sudo nixos-rebuild switch --flake $dir#
          }
          commit() {
              $git -C $dir pull
              $git -C $dir add .
              $git -C $dir commit -m "automated commit"
              $git -C $dir push
          }
          status() {
              $git -C $dir status
          }
          update() {
              inputs
              rebuild
          }
          gc() {
              nix-collect-garbage -d
          }
          pull() {
              $git -C $dir pull
          }
          apply() {
              $git -C $dir pull
              sudo nix run $dir#apps.nixinate.$1
          }
          micro_local() {
            if [ $# -lt 1 ]; then
              NAMES="$(ls -1 /var/lib/microvms)"
            else
              NAMES="$@"
            fi

            for NAME in $NAMES; do
              echo $NAME
              sudo microvm -Ru $NAME
            done
          }

          case "$1" in
              inputs) inputs;;
              rebuild) rebuild;;
              commit) commit;;
              update) update;;
              gc) gc;;
              status) status;;
              pull) pull;;
              apply) apply $2;;
              micro-local)
                shift
                micro_local $@;;
              micro)
                shift
                sudo ${pkgs.openssh}/bin/ssh -t raab@nix-hypervisor "sudo flock -w 60 /dev/shm/nox-micro nox micro-local $@";;
          esac
        ''
      )
    ];
  };
}
