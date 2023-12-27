{pkgs, ...}: {
  services.tailscale.enable = true;
  networking = {
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
    };
    networkmanager.enable = true;
  };
  networking.firewall = {
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [53];
  };
  powerManagement = {
    # Sata power management
    scsiLinkPolicy = "med_power_with_dipm";
    # Spin down HDD after 1 hour
    powerUpCommands = "${pkgs.hdparm}/sbin/hdparm -S 242 /dev/sda";
  };

  powerManagement.powertop.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.utf8";
}
