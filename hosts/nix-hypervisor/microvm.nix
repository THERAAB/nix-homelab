{self, ...}: {
  microvm = {
    autostart = ["micro-media" "micro-server" "micro-unifi"];
    vms = {
      micro-media = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab"; #TODO: remove imperative updates
      };
      micro-server.config.imports = [
        ../../share/lib/modules/nixos/yamlConfigMaker
        ../../share/microvm
        ../../share/all
        ../micro-server
      ];
      micro-unifi.config.imports = [
        ../../share/lib/modules/nixos/yamlConfigMaker
        ../../share/microvm
        ../../share/all
        ../micro-unifi
      ];
    };
  };
}
