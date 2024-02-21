{self, ...}: {
  microvm = {
    autostart = ["micro-media"];
    vms = {
      micro-media = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
    };
  };
}
