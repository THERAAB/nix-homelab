{config, ...}: let
  custom-blueprints-dir = "/var/lib/hass/blueprints/automation/custom";
  system-blueprints-dir = "/nix/persist/nix-homelab/systems/x86_64-linux/micro-automate/home-assistant/blueprints"; 
in {
  networking.hostName = "micro-automate";
  microvm = {
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = config.networking.hostName;
        mac = "02:00:00:00:00:06";
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        source = "/sync";
        mountPoint = "/sync";
        tag = "sync";
      }
      {
        proto = "virtiofs";
        source = system-blueprints-dir;
        mountPoint = custom-blueprints-dir;
        tag = "custom-blueprints";
      }
    ];
    devices = [
      {
        bus = "pci";
        path = "0000:00:14.0"; # Passthrough whole USB bus because single usb device passthrough doesn't work
      }
    ];
  };
}
