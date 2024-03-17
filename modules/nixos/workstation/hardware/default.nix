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
    boot = {
      initrd.verbose = false;
      consoleLogLevel = 0;
      kernelParams = ["quiet" "splash" "rd.systemd.show_status=false" "udev.log_priority=3" "boot.shell_on_fail"];
      loader.grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        configurationLimit = 10;
        gfxmodeEfi = "text";
        splashImage = null;
      };
    };
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
    fileSystems = {
      "/sync" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = ["subvol=sync" "compress=zstd" "noatime"];
      };
    };
  };
}
