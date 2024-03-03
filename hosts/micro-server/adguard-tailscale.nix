{...}: let
  network = import ../../share/network.properties.nix;
in {
  imports = [
    ../../share/optional/adguard.nix
  ];
  services.adguardhome.settings = {
    bind_host = network.micro-server.local.ip;
    dns = {
      bind_hosts = [network.micro-server.tailscale.ip network.micro-server.local.ip];
      rewrites = [
        {
          domain = "cache.${network.domain}";
          answer = "${network.nix-hypervisor.tailscale.ip}";
        }
        {
          domain = "netdata.${network.domain}";
          answer = "${network.nix-hypervisor.tailscale.ip}";
        }
        {
          domain = "sync.${network.domain}";
          answer = "${network.nix-hypervisor.tailscale.ip}";
        }
        {
          domain = "home-assistant.${network.domain}";
          answer = "${network.nix-hypervisor.tailscale.ip}";
        }
        {
          domain = "vuetorrent.${network.domain}";
          answer = "${network.micro-media.tailscale.ip}";
        }
        {
          domain = "unifi.${network.domain}";
          answer = "${network.micro-networking.tailscale.ip}";
        }
        {
          domain = "olivetin.${network.domain}";
          answer = "${network.nix-hypervisor.tailscale.ip}";
        }
        {
          domain = "${network.domain}";
          answer = "${network.micro-server.tailscale.ip}";
        }
        {
          domain = "*.${network.domain}";
          answer = "${network.micro-server.tailscale.ip}";
        }
      ];
    };
  };
}
