{...}: let
  network = import ../../share/network.properties.nix;
in {
  imports = [
    ../../share/optional/adguard.nix
  ];
  services.adguardhome.settings = {
    bind_host = network.micro-network.local.ip;
    dns = {
      bind_hosts = [network.micro-network.local.ip network.micro-network.tailscale.ip];
      rewrites = [
        {
          domain = "cache.${network.domain}";
          answer = "${network.nix-hypervisor.local.ip}";
        }
        {
          domain = "netdata.${network.domain}";
          answer = "${network.nix-hypervisor.local.ip}";
        }
        {
          domain = "sync.${network.domain}";
          answer = "${network.nix-hypervisor.local.ip}";
        }
        {
          domain = "home-assistant.${network.domain}";
          answer = "${network.nix-hypervisor.local.ip}";
        }
        {
          domain = "vuetorrent.${network.domain}";
          answer = "${network.micro-media.local.ip}";
        }
        {
          domain = "olivetin.${network.domain}";
          answer = "${network.nix-hypervisor.local.ip}";
        }
        {
          domain = "jellyfin.${network.domain}";
          answer = "${network.nix-server.local.ip}";
        }
        {
          domain = "${network.domain}";
          answer = "${network.micro-network.local.ip}";
        }
        {
          domain = "*.${network.domain}";
          answer = "${network.micro-network.local.ip}";
        }
      ];
    };
  };
}
