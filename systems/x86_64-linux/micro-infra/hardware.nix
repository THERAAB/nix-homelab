{
  config,
  self,
  ...
}: let
  hypervisor-icons-dir = self + "/assets/icons";
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
      {
        proto = "virtiofs";
        source = "/run/secrets/${config.networking.hostName}";
        mountPoint = "/run/secrets";
        tag = "secrets";
      }
    ];
  };
}
