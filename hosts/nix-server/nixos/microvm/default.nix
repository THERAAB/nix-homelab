{self, ...}: {
  microvm = {
    autostart = ["micro1" "micro2"];
    vms = {
      micro1 = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
      micro2 = {
        flake = self;
        updateFlake = "git+file:///nix/persist/nix-homelab";
      };
    };
  };
}
