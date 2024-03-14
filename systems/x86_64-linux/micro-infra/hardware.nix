{config, ...}: let
  hypervisor-icons-dir = "/nix/persist/nix-homelab/assets/icons";
  mount-icons-dir = "/icons";
in {
  networking.hostName = "micro-infra";
  microvm = {
    mem = 4096;
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = config.networking.hostName;
        mac = "02:00:00:00:00:03";
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        source = hypervisor-icons-dir;
        mountPoint = mount-icons-dir;
        tag = "homer-icons";
      }
    ];
  };
}
