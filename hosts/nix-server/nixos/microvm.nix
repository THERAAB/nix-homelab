{...}: {
  microvm = {
    autostart = ["my-microvm"];
    vms.my-microvm.config = {
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
        hypervisor = "cloud-hypervisor";
        interfaces = [
          {
            type = "macvtap";
            macvtap = {
              mode = "private";
              link = "enp3s0";
            };
            id = "microvm";
            mac = "02:00:00:00:00:01";
          }
        ];
      };
      
      system.stateVersion = "23.11";
      users.users.root.password = "";
      networking.hostName = "my-microvm";
      services.openssh = {
        enable = true;
        settings.PermitRootLogin = "yes";
      };
    };
    vms.my-microvm2.config = {
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
        hypervisor = "cloud-hypervisor";
      };
      system.stateVersion = "23.11";
      users.users.root.password = "";
      networking.hostName = "my-microvm2";
    };
  };
}
