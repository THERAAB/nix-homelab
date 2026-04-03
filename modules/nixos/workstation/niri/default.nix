{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab;
let
  cfg = config.nix-homelab.workstation.niri;
in
{
  options.nix-homelab.workstation.niri = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup niri");
  };
  config = mkIf cfg.enable {
    programs.niri.enable = true;
    environment = {
      systemPackages = with pkgs; [
        xwayland-satellite # xwayland support
      ];
      pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];
    };
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${config.programs.niri.package}/bin/niri-session";
          user = "raab";
        };
      };
    };
  };
}
