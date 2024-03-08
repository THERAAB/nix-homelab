{config, ...}: {
  #systemd.tmpfiles.rules = [
  #  # creates a symlink of each MicroVM's journal under the host's /var/log/journal
  #  "L+ /var/log/journal/${config.microvm.vms.micro-media.config.} - - - - /var/lib/microvms/${vmHost}/journal/${machineId}"
  #];
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
