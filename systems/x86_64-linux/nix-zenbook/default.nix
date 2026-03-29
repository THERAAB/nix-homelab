{ self, config, ... }:
{
  imports = [
    (self + /share/nixos/workstation)
    ./hardware.nix
  ];
  nix-homelab.workstation.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  programs.niri.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "raab";
      };
    };
  };
}
