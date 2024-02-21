{...}: let
  port = 3000;
  settings = (import ./settings.nix).settings;
in {
  services = {
    adguardhome = {
      mutableSettings = false;
      enable = true;
      settings = settings;
    };
  };
  networking.firewall.allowedTCPPorts = [port];
}
