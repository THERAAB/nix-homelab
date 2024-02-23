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
    mem = lib.mkDefault 2048;
    vcpu = lib.mkDefault 1;
  };
}
