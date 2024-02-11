{self, ...}: {
  microvm = {
    autostart = ["micro1"];
    vms.micro1 = {
      flake = self;
      updateFlake = "git+file:///etc/nixos";
    };
  };
}
