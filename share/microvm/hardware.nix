{
  config,
  lib,
  ...
}: let
  network = import ../network.properties.nix;
in {
  environment.etc."machine-id" = {
    mode = "0644";
    text = network.${config.networking.hostName}.machine-id + "\n";
  };
  microvm = {
    writableStoreOverlay = "/nix/.rw-store";
    volumes = [
      {
        image = "nix-store-overlay.img";
        mountPoint = config.microvm.writableStoreOverlay;
        size = 2048;
      }
    ];
    hypervisor = "cloud-hypervisor";
    shares = [
      #{ #TODO ?
      #  source = "/nix/store";
      #  mountPoint = "/nix/.ro-store";
      #  tag = "ro-store";
      #  proto = "virtiofs";
      #}
      {
        source = "/var/lib/microvms/${config.networking.hostName}/storage/journal";
        mountPoint = "/var/log/journal";
        tag = "journal";
        proto = "virtiofs";
        socket = "journal.sock";
      }
      {
        proto = "virtiofs";
        source = "/run/secrets/${config.networking.hostName}";
        mountPoint = "/run/secrets";
        tag = "secrets";
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
    mem = lib.mkDefault 2024;
    vcpu = lib.mkDefault 1;
  };
  fileSystems = {
    "/etc/ssh".neededForBoot = true;
    "/var/lib".neededForBoot = true;
    "/var/log/journal".neededForBoot = true;
  };
}
