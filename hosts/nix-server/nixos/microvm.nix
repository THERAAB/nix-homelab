{...}: {
  microvm.autostart = [
    "my-microvm"
  ];
  microvm.vms = {
    my-microvm.config = {
      microvm = {
        shares = [
          {
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
            tag = "ro-store";
            proto = "virtiofs";
          }
        ];
        mem = 2048;
        vcpu = 1;
      };
      system.stateVersion = "23.11";
      users.users.root.password = "";
      networking.hostName = "my-microvm";
    };
  };
}
