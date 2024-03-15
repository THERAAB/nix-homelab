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
          case "$1" in
              inputs) inputs;;
              rebuild) rebuild;;
              commit) commit;;
              update) update;;
              gc) gc;;
              status) status;;
              pull) pull;;
          esac
        ''
      )
    ];
  };
}
