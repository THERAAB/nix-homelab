{
  self,
  properties,
  ...
}: let
  microvm-config = {
    flake = self;
    updateFlake = "github:THERAAB/nix-homelab";
  };
  micro-media = import ../micro-media;
in {
  systemd.tmpfiles.rules = [
    # Share journald logs on nix-hypervisor
    "L+ /var/log/journal/${properties.network.micro-media.machine-id}      -   -   -   -   /var/lib/microvms/micro-media/storage/journal/${properties.network.micro-media.machine-id}         "
    "L+ /var/log/journal/${properties.network.micro-server.machine-id}     -   -   -   -   /var/lib/microvms/micro-server/storage/journal/${properties.network.micro-server.machine-id}       "
    "L+ /var/log/journal/${properties.network.micro-tailscale.machine-id}  -   -   -   -   /var/lib/microvms/micro-tailscale/storage/journal/${properties.network.micro-tailscale.machine-id} "
    "L+ /var/log/journal/${properties.network.micro-infra.machine-id}      -   -   -   -   /var/lib/microvms/micro-infra/storage/journal/${properties.network.micro-infra.machine-id}         "
    "L+ /var/log/journal/${properties.network.micro-download.machine-id}   -   -   -   -   /var/lib/microvms/micro-download/storage/journal/${properties.network.micro-download.machine-id}   "
    "L+ /var/log/journal/${properties.network.micro-automate.machine-id}   -   -   -   -   /var/lib/microvms/micro-automate/storage/journal/${properties.network.micro-automate.machine-id}   "
  ];
  microvm = {
    autostart = [
      "micro-media"
      "micro-server"
      "micro-infra"
      "micro-tailscale"
      "micro-download"
      "micro-automate"
    ];
    vms = {
      micro-media = micro-media;
      micro-server = microvm-config;
      micro-infra = microvm-config;
      micro-tailscale = microvm-config;
      micro-download = microvm-config;
      micro-automate = microvm-config;
    };
  };
}
