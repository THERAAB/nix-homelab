{config, ...}: let
  hypervisor-icons-dir = "/nix/persist/nix-homelab/assets/icons";
  mount-icons-dir = "/icons";
in {
  imports = [
    ./adguard.nix
    ./hardware.nix
  ];
  nix-homelab = {
    core = {
      flakes.enable = true;
      system.enable = true;
    };
    wrappers = {
      gatus.enable = true;
      homer.enable = true;
      gotify.enable = true;
      unifi.enable = true;
    };
    microvm = {
      podman.enable = true;
      system.enable = true;
      hardware = {
        enable = true;
        hostName = config.networking.hostName;
      };
    };
  };
  microvm.shares = [
    {
      proto = "virtiofs";
      source = hypervisor-icons-dir;
      mountPoint = mount-icons-dir;
      tag = "homer-icons";
    }
  ];
}
