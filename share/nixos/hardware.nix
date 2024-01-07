{...}: {
  systemd.tmpfiles.rules = [
    "d    /var/log/smartd  -    smartd smartd  -   - "
    "Z    /var/log/smartd  740  smartd smartd  -   - "
  ];
  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    smartd = {
      enable = true;
      extraOptions = [
        "-A"
        "/var/log/smartd/"
        "--interval=3600"
      ];
    };
    tailscale.enable = true;
  };
  networking = {
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
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
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.utf8";
}
