{self, ...}: {
  microvm = {
    autostart = ["micro-media"];
    vms = {
      micro-media = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
      #micro-server = {
      #  flake = self;
      #  updateFlake = "git+file:///nix/persist/nix-homelab";
      #};
    };
  };
}
