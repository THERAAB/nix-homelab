{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.hardware;
in {
  options.nix-homelab.workstation.hardware = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup hardware");
  };
  config = mkIf cfg.enable {
    services = {
      irqbalance.enable = true;
      smartd.enable = true;
      avahi = {
        enable = true;
        nssmdns = true;
        openFirewall = true;
      };
      printing = {
        enable = true;
        drivers = [pkgs.epson-escpr];
      };
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
    networking.networkmanager.wifi.powersave = true;
    sound.enable = true;
    security = {
      rtkit.enable = true;
      polkit.enable = true;
    };
    hardware = {
      pulseaudio.enable = false;
      bluetooth.enable = true;
    };
  };
}
