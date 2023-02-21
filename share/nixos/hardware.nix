{ config, pkgs, ... }:
{
  services.tailscale.enable = true;
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 53 ];
    trustedInterfaces = [ "tailscale0" ];
  };

  powerManagement.powertop.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.utf8";
}
