{...}: {
  services.caddy.virtualHosts."ag2.pumpkin.rodeo" = {
    useACMEHost = "pumpkin.rodeo";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy 192.168.3.3:3000
    '';
  };
  microvm = {
    autostart = ["my-microvm" "my-microvm2"];
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
              mode = "bridge";
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
      networking.nameservers = ["1.1.1.1"];
      services.adguardhome = {
        mutableSettings = true;
        enable = true;
      };
      networking.firewall.allowedTCPPorts = [3000];
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
        interfaces = [
          {
            type = "macvtap";
            macvtap = {
              mode = "bridge";
              link = "enp3s0";
            };
            id = "microvm2";
            mac = "02:00:00:00:00:02";
          }
        ];
      };
      system.stateVersion = "23.11";
      users.users.root.password = "";
      networking.hostName = "my-microvm2";
      services.openssh = {
        enable = true;
        settings.PermitRootLogin = "yes";
      };
      networking.nameservers = ["1.1.1.1"];
    };
  };
}
