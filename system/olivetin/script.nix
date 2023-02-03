{ config, pkgs, ... }:
{
  shellScript = pkgs.writeShellScript "commands.sh" ''
    case "$1" in
      reboot)
        reboot now;;
      jellyfin_reboot)
        podman stop jellyfin
        sleep 1
        podman start jellyfin
    esac
  '';
}