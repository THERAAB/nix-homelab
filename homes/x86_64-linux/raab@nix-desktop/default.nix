{ pkgs, ... }:
{
  imports = [
    ./niri.nix
    ./noctalia.nix
  ];
  nix-homelab = {
    workstation.enable = true;
    wrappers.mangohud.enable = true;
  };
  home.packages = with pkgs; [
    protonup-ng
    polychromatic
    snapper-gui
  ];
  systemd.user.services.steam = {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit.After = [ "graphical-session.target" ];
    Service.ExecStart = "${pkgs.steam}/bin/steam -nochatui -nofriendsui -silent";
  };
}
