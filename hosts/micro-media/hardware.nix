{config, ...}: {
  networking.hostName = "micro-media";
  environment.etc."machine-id" = {
    mode = "0644";
    text =
      # change this to suit your flake's interface
      "5537b436ea484e698e6c3426f309a4b8\n";
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
