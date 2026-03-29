{ pkgs, ... }:
{
  nix-homelab = {
    workstation.enable = true;
    wrappers.mangohud.enable = true;
  };
  home.packages = with pkgs; [
    protonup-ng
    polychromatic
    snapper-gui
    jetbrains.idea-oss
  ];
  systemd.user.services.steam = {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit.After = [ "graphical-session.target" ];
    Service.ExecStart = "${pkgs.steam}/bin/steam -nochatui -nofriendsui -silent";
  };
}
