{ config, pkgs, ... }:

pkgs.writeShellScript "commands.sh" ''
  case "$1" in
    reboot)
      reboot now;;
    jellyfin_reboot)
      podman stop jellyfin
      sleep 1
      podman start jellyfin;;
    gatus_reboot)
      podman stop gatus
      sleep 1
      podman start gatus;;
  esac
''
