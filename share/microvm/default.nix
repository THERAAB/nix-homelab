{
  lib,
  config,
  ...
}: {
  microvm = {
    hypervisor = "cloud-hypervisor";
    mem = lib.mkDefault 2024;
    vcpu = lib.mkDefault 1;
    shares = [
      {
        source = "/var/lib/microvms/${config.networking.hostName}/storage/journal";
        mountPoint = "/var/log/journal";
        tag = "journal";
        proto = "virtiofs";
        socket = "journal.sock";
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
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }
      {
        proto = "virtiofs";
        source = "/run/secrets/${config.networking.hostName}";
        mountPoint = "/run/secrets";
        tag = "secrets";
      }
    ];
  };
  fileSystems = {
    "/etc/ssh".neededForBoot = true;
    "/var/lib".neededForBoot = true;
    "/var/log/journal".neededForBoot = true;
  };
}
