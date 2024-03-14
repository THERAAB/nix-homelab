{...}: let
  custom-blueprints-dir = "/var/lib/hass/blueprints/automation/custom";
  system-blueprints-dir = "/nix/persist/nix-homelab/systems/x86_64-linux/micro-automate/home-assistant/blueprints";
in {
  imports = [
    ./hardware.nix
    ./home-assistant
  ];
  nix-homelab.wrappers.home-assistant.enable = true;
  microvm = {
    devices = [
      {
        bus = "pci";
        path = "0000:00:14.0"; # Passthrough whole USB bus because single usb device passthrough doesn't work
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        source = system-blueprints-dir;
        mountPoint = custom-blueprints-dir;
        tag = "custom-blueprints";
      }
    ];
  };
}
