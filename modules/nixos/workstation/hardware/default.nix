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
      fstrim.enable = true;
      irqbalance.enable = true;
      fwupd.enable = true;
      smartd.enable = true;
      tailscale.enable = true;
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

    networking = {
      networkmanager = {
        enable = true;
        wifi.powersave = true;
      };
      firewall = {
        enable = true;
        trustedInterfaces = ["tailscale0"];
      };
    };

    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.utf8";

    # Enable sound with pipewire.
    sound.enable = true;
    security = {
      rtkit.enable = true;
      polkit.enable = true;
    };
    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
      pulseaudio.enable = false;
      bluetooth.enable = true;
    };
  };
}
