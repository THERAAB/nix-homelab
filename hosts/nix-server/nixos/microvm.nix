{...}: {
  #networking.useNetworkd = true;
  systemd.network.enable = true;

  systemd.network = {
    netdevs."10-microvm".netdevConfig = {
      Kind = "bridge";
      Name = "microvm";
    };
    networks."10-microvm" = {
      matchConfig.Name = "microvm";
      networkConfig = {
        DHCPServer = true;
        IPv6SendRA = true;
      };
      addresses = [
        {
          addressConfig.Address = "10.0.0.1/24";
        }
        {
          addressConfig.Address = "fd12:3456:789a::1/64";
        }
      ];
      ipv6Prefixes = [
        {
          ipv6PrefixConfig.Prefix = "fd12:3456:789a::/64";
        }
      ];
    };
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
            id = "vm-test1";
            mac = "02:00:00:00:00:01";
          }
        ];
      };
      #  networking.interfaces.eth0.useDHCP = true;
      system.stateVersion = "23.11";
      users.users.root.password = "";
      networking.hostName = "my-microvm";
      networking.firewall.allowedTCPPorts = [22];
      services.openssh = {
        enable = true;
        settings.PermitRootLogin = "yes";
      };
      systemd.network.enable = true;
      systemd.network = {
        networks."11-microvm" = {
          matchConfig.Name = "vm-*";
          # Attach to the bridge that was configured above
          networkConfig.Bridge = "microvm";
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
