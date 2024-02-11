{...}: {
  services.adguardhome = {
    mutableSettings = true;
    enable = true;
  };
  networking.firewall.allowedTCPPorts = [3000];
}
