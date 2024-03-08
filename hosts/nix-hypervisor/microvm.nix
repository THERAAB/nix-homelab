{config, ...}: let
  network = import ../../share/network.properties.nix;
  inherit (config.microvm.vms.micro-media.config.systemd) machine-id;
in {
  systemd.tmpfiles.rules = [
    # Share journald logs on nix-hypervisor
    "L+ /var/log/journal/${machine-id}      -   -   -   -   /var/lib/microvms/micro-media/storage/journal/${network.micro-media.machine-id}         "
    "L+ /var/log/journal/${network.micro-server.machine-id}     -   -   -   -   /var/lib/microvms/micro-server/storage/journal/${network.micro-server.machine-id}       "
    "L+ /var/log/journal/${network.micro-tailscale.machine-id}  -   -   -   -   /var/lib/microvms/micro-tailscale/storage/journal/${network.micro-tailscale.machine-id} "
    "L+ /var/log/journal/${network.micro-utils.machine-id}      -   -   -   -   /var/lib/microvms/micro-utils/storage/journal/${network.micro-utils.machine-id}         "
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
      micro-utils.config.imports = [
        ../../share/lib/modules/nixos/yamlConfigMaker
        ../../share/microvm
        ../../share/all
        ../micro-utils
      ];
      micro-tailscale.config.imports = [
        ../../share/microvm
        ../../share/all
        ../micro-tailscale
      ];
    };
  };
}
