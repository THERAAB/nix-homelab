{self, ...}: {
  microvm = {
    autostart = ["micro-media" "micro-server" "micro-unifi"];
    vms = {
      micro-media = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab"; #TODO: remove imperative updates
      };
      micro-server = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
      micro-unifi = {
        config = {
          imports = [
            ../../share/lib/modules/nixos/yamlConfigMaker
            ../../share/microvm
            ../../share/all
            ../micro-unifi
          ];
        };
      };
    };
  };
}
