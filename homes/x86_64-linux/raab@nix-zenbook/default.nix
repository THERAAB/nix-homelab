{pkgs, ...}: {
  imports = [
    ./gnome.nix
  ];
  nix-homelab = {
    workstation.enable = true;
    programs.libinput-gestures.enable = true;
  };
  home.packages = with pkgs; [
    powertop
  ];
}
