{...}: let
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
    vms = {
      micro-media.config.imports = [
        ../../share/microvm
        ../../share/all
        ../micro-media
      ];
      micro-server.config.imports = [
        ../../share/microvm
        ../../share/all
        ../micro-server
      ];
      micro-infra.config.imports = [
        ../../share/lib/modules/nixos/yamlConfigMaker
        ../../share/microvm
        ../../share/all
        ../micro-infra
      ];
      micro-tailscale.config.imports = [
        ../../share/microvm
        ../../share/all
        ../micro-tailscale
      ];
      micro-download.config.imports = [
        ../../share/microvm
        ../../share/all
        ../micro-download
      ];
      micro-automate.config.imports = [
        ../../share/microvm
        ../../share/all
        ../micro-automate
      ];
    };
  };
}
