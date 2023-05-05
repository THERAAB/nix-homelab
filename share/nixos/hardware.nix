{ config, pkgs, ... }:
{
  services.tailscale.enable = true;
  networking = {
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
    };
    interfaces.enp3s0.wakeOnLan.enable = true;
  };

  powerManagement.powertop.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.utf8";
}
