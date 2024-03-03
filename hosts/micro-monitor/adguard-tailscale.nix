{...}: let
  network = import ../../share/network.properties.nix;
in {
  imports = [
    ../../share/optional/adguard.nix
  ];
  services.adguardhome.settings = {
    bind_host = network.micro-monitor.local.ip;
    dns = {
      bind_hosts = [network.micro-monitor.tailscale.ip network.micro-monitor.local.ip];
      rewrites = [
        ##TODO: move caddy to micro-network
        {
          domain = "vuetorrent.${network.domain}";
          answer = "${network.micro-media.tailscale.ip}";
        }
        {
          domain = "gotify.${network.domain}";
          answer = "${network.micro-monitor.tailscale.ip}";
        }
        {
          domain = "${network.domain}";
          answer = "${network.micro-network.tailscale.ip}";
        }
        {
          domain = "*.${network.domain}";
          answer = "${network.micro-network.tailscale.ip}";
        }
      ];
    };
  };
}
