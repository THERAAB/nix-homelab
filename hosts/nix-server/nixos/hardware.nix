{ config, pkgs, ... }:
{
  networking.hostName = "nix-server";
  networking.networkmanager.enable = true;
  powerManagement = {
    # Sata power management
    scsiLinkPolicy = "med_power_with_dipm";
    # Spin down HDD after 1 hour
    powerUpCommands = "${pkgs.hdparm}/sbin/hdparm -S 242 /dev/sda";
  };

  # Hardware acceleration for intel
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
