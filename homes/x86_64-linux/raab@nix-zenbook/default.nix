{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.niri-flake.homeModules.niri
    inputs.noctalia.homeModules.default
  ];
  nix-homelab = {
    workstation.enable = true;
    programs.libinput-gestures.enable = true;
  };
  home.packages = with pkgs; [
    powertop
  ];
}
