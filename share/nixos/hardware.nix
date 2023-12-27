{pkgs, ...}: {
  services = {
    fstrim.enable = true;
    irqbalance.enable = true;
    fwupd.enable = true;
    smartd.enable = true;
    tailscale.enable = true;
  };
  networking = {
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [53];
    };
    networkmanager.enable = true;
  };
  powerManagement = {
    # Sata power management
    scsiLinkPolicy = "med_power_with_dipm";
    # Spin down HDD after 1 hour
    powerUpCommands = "${pkgs.hdparm}/sbin/hdparm -S 242 /dev/sda";
    powertop.enable = true;
  };
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.utf8";
}
