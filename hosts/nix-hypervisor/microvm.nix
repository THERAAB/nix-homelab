{...}: {
  microvm = {
    #autostart = ["micro-media" "micro-server" "micro-network" "micro-tailscale"];
    vms = {
      micro-media.config.imports = [
        ../../share/microvm
        ../../share/all
        ../micro-media
      ];
      micro-server.config.imports = [
        ../../share/lib/modules/nixos/yamlConfigMaker
        ../../share/microvm
        ../../share/all
        ../micro-server
      ];
      micro-network.config.imports = [
        ../../share/lib/modules/nixos/yamlConfigMaker
        ../../share/microvm
        ../../share/all
        ../micro-network
      ];
      micro-tailscale.config.imports = [
        ../../share/microvm
        ../../share/all
        ../micro-tailscale
      ];
    };
  };
}
