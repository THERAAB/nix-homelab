{
  config,
  lib,
  ...
}: {
  microvm = {
    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }
      {
        proto = "virtiofs";
        source = "/run/secrets";
        mountPoint = "/run/secrets";
        tag = "secrets"; #TODO: remove
      }
      {
        proto = "virtiofs";
        source = "/var/lib/microvms/${config.networking.hostName}/storage/etc/ssh"; 
        mountPoint = "/etc/ssh";
        tag = "ssh";
      }
      {
        proto = "virtiofs";
        source = "/var/lib/microvms/${config.networking.hostName}/storage/var/lib";
        mountPoint = "/var/lib";
        tag = "var-lib";
      }
    ];
    mem = lib.mkDefault 2048;
    vcpu = lib.mkDefault 1;
  };
}
