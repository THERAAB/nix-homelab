{...}: {
  networking.useNetworkd = true;
  systemd.network.enable = true;

  systemd.network.networks."10-lan" = {
    matchConfig.Name = ["eno1" "vm-1"];
    networkConfig = {
      Bridge = "br0";
    };
  };

  systemd.network.netdevs."br0" = {
    netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
  };

  systemd.network.networks."10-lan-bridge" = {
    matchConfig.Name = "br0";
    networkConfig = {
      Address = ["192.168.3.100/24"];
      Gateway = "192.168.3.1";
      DNS = ["192.168.3.2"];
      # IPv6AcceptRA = true;
    };
    linkConfig.RequiredForOnline = "routable";
  };
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
            type = "tap";
            id = "vm-1";
            mac = "02:00:00:00:00:01";
          }
        ];
      };
      system.stateVersion = "23.11";
      users.users.root.password = "";
      networking.hostName = "my-microvm";
      systemd.network.enable = true;

      systemd.network.networks."20-lan" = {
        matchConfig.Type = "ether";
        networkConfig = {
          Address = ["192.168.3.100/24"];
          Gateway = "192.168.3.1";
          DNS = ["192.168.3.2"];
          #IPv6AcceptRA = true;
          DHCP = "no";
        };
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