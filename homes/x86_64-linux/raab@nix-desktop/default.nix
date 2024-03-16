{pkgs, ...}: {
  imports = [
    ./gnome.nix
  ];
  nix-homelab = {
    workstation.enable = true;
    programs.headsetcontrol.enable = true;
    wrappers.mangohud.enable = true;
  };
  home.packages = with pkgs; [
    heroic
    protonup
    polychromatic
    snapper-gui
    jetbrains.idea-community
  ];
  systemd.user.services.steam = {
    Install.WantedBy = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Service.ExecStart = "${pkgs.steam}/bin/steam -nochatui -nofriendsui -silent";
  };
}
