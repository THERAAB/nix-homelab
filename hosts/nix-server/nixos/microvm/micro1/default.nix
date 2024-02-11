{lib, ...}: {
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
        id = "micro1";
        mac = "02:00:00:00:00:01";
      }
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.11";
  users.users.root.password = "";
  networking.hostName = "micro1";
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
}
