{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # ./gnome.nix
    inputs.niri-flake.homeModules.niri
    inputs.noctalia.homeModules.default
  ];
  nix-homelab = {
    workstation.enable = true;
    programs.libinput-gestures.enable = true;
  };
  programs.niri = {
    enable = true;
    settings.binds = {
      "Mod+R".action.spawn = "fuzzel";
    };
  };
  programs.fuzzel.enable = true;
  programs.alacritty.enable = true;
  programs.noctalia-shell.enable = true;
  home.packages = with pkgs; [
    powertop
  ];
}
