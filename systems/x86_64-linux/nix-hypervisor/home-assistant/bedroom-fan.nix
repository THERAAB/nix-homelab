{pkgs, ...}: let
in {
  services.home-assistant = {
    customComponents = [
      pkgs.nix-homelab.home-assistant-hubspace
    ];
  };
}
