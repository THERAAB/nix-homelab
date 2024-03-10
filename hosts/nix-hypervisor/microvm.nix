{self, ...}: let
  network = import ../../share/network.properties.nix;
in {
  systemd.tmpfiles.rules = [
    # Share journald logs on nix-hypervisor
    "L+ /var/log/journal/${network.micro-media.machine-id}      -   -   -   -   /var/lib/microvms/micro-media/storage/journal/${network.micro-media.machine-id}         "
    "L+ /var/log/journal/${network.micro-server.machine-id}     -   -   -   -   /var/lib/microvms/micro-server/storage/journal/${network.micro-server.machine-id}       "
    "L+ /var/log/journal/${network.micro-tailscale.machine-id}  -   -   -   -   /var/lib/microvms/micro-tailscale/storage/journal/${network.micro-tailscale.machine-id} "
    "L+ /var/log/journal/${network.micro-infra.machine-id}      -   -   -   -   /var/lib/microvms/micro-infra/storage/journal/${network.micro-infra.machine-id}         "
    "L+ /var/log/journal/${network.micro-download.machine-id}   -   -   -   -   /var/lib/microvms/micro-download/storage/journal/${network.micro-download.machine-id}   "
    "L+ /var/log/journal/${network.micro-automate.machine-id}   -   -   -   -   /var/lib/microvms/micro-automate/storage/journal/${network.micro-automate.machine-id}   "
  ];
  microvm = {
    autostart = ["micro-media" "micro-server" "micro-infra" "micro-tailscale" "micro-download" "micro-automate"];
    vms = {
      micro-media = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
      micro-server = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
      micro-infra = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
      micro-tailscale = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
      micro-download = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
      micro-automate = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
    };
  };
}
