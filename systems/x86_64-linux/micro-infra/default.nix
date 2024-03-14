{...}: let
  hypervisor-icons-dir = "/nix/persist/nix-homelab/assets/icons";
  mount-icons-dir = "/icons";
in {
  imports = [
    ./adguard.nix
    ./hardware.nix
  ];
  nix-homelab = {
    microvm.enable = true;
    wrappers = {
      gatus.enable = true;
      homer.enable = true;
      gotify.enable = true;
      unifi.enable = true;
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
