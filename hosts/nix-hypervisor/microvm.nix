{...}: {
  microvm = {
    autostart = ["micro-media" "micro-server" "micro-networking"];
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
      micro-networking.config.imports = [
        ../../share/microvm
        ../../share/all
        ../micro-networking
      ];
    };
  };
}
