{...}: let
  network = import ../../share/network.properties.nix;
in {
  systemd.tmpfiles.rules = [
    "L+ /var/log/journal/${network.micro-media.machine-id} - - - - /var/lib/microvms/micro-media/storage/journal/${network.micro-media.machine-id}"
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
