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
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.11";
  users.users.root.password = "";
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };
  networking.nameservers = ["1.1.1.1"];
}
