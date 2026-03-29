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
    programs.libinput-gestures.enable = false;
  };
  programs.niri = {
    enable = true;
    settings = {
      binds = {
        "Mod+R".action.spawn = "fuzzel";
        "Mod+Return".action.spawn = "kitty";
      };
      spawn-at-startup = [
        { command = [ "noctalia-shell" ]; }
      ];
    };
  };
  programs.fuzzel.enable = true;
  programs.noctalia-shell.enable = true;
  home.packages = with pkgs; [
    powertop
  ];
}
