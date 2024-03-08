{
  lib,
  config,
  ...
}: {
  networking.hostName = "micro-media";
  environment.etc."machine-id" = {
    mode = "0644";
    text =
      # change this to suit your flake's interface
      lib.addresses.machineId.${config.networking.hostName} + "\n";
  };

  microvm = {
    shares = [
      {
        # On the host
        source = "/var/lib/microvms/${config.networking.hostName}/journal";
        # In the MicroVM
        mountPoint = "/var/log/journal";
        tag = "journal";
        proto = "virtiofs";
        socket = "journal.sock";
      }
    ];
    mem = 6144;
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = config.networking.hostName;
        mac = "02:00:00:00:00:01";
      }
    ];
  };
  services.tailscale.enable = true; # TODO: remove, merge journal
}
