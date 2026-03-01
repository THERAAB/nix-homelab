{
  self,
  properties,
  ...
}: let
  microvm-config = {
    flake = self;
    updateFlake = "github:THERAAB/nix-homelab";
  };
in {
  systemd.tmpfiles.rules = [
    # Share journald logs on nix-hypervisor
    "L+ /var/log/journal/${properties.network.micro-tailscale.machine-id}  -   -   -   -   /var/lib/microvms/micro-tailscale/storage/journal/${properties.network.micro-tailscale.machine-id} "
  ];
  microvm = {
    autostart = [
      "micro-tailscale"
    ];
    vms = {
      micro-tailscale = microvm-config;
    };
  };
}
