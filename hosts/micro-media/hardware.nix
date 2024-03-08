{config, ...}: let
  network = import ../../share/network.properties.nix;
in {
  networking.hostName = "micro-media";
  environment.etc."machine-id" = {
    mode = "0644";
    text =
      network.micro-media.machine-id + "\n";
  };
  microvm = {
    shares = [
      {
        source = "/var/lib/microvms/${config.networking.hostName}/storage/journal";
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
