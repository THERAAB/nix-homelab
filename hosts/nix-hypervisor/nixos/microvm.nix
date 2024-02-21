{self, ...}: {
  microvm = {
    autostart = ["micro-media" "micro-server"];
    vms = {
      micro-media = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
    };
    vms = {
      micro-server = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
    };
  };
}
