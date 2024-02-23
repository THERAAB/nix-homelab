{...}: {
  services = {
    fstrim.enable = true;
    fwupd.enable = true;
  };
  networking = {
    firewall = {
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [53];
    };
  };
  powerManagement = {
    enable = true;
    # Sata power management
    scsiLinkPolicy = "med_power_with_dipm";
    powertop.enable = true;
  };
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };
}
