{...}: {
  microvm = {
    autostart = ["micro-media" "micro-server" "micro-network" "micro-monitor"];
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
        ../../share/microvm
        ../../share/all
        ../micro-network
      ];
      micro-monitor.config.imports = [
        ../../share/lib/modules/nixos/yamlConfigMaker
        ../../share/microvm
        ../../share/all
        ../micro-monitor
      ];
    };
  };
}
