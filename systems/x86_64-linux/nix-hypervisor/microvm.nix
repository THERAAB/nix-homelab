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
    "L+ /var/log/journal/${properties.network.micro-infra.machine-id}      -   -   -   -   /var/lib/microvms/micro-infra/storage/journal/${properties.network.micro-infra.machine-id}         "
    "L+ /var/log/journal/${properties.network.micro-automate.machine-id}   -   -   -   -   /var/lib/microvms/micro-automate/storage/journal/${properties.network.micro-automate.machine-id}   "
  ];
  microvm = {
    autostart = [
      "micro-infra"
      "micro-tailscale"
      "micro-automate"
    ];
    vms = {
      micro-infra = microvm-config;
      micro-tailscale = microvm-config;
      micro-automate = microvm-config;
    };
  };
}
