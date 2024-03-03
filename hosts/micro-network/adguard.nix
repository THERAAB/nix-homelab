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
          domain = "vuetorrent.${network.domain}";
          answer = "${network.micro-media.local.ip}";
        }
        {
          domain = "gotify.${network.domain}";
          answer = "${network.micro-monitor.local.ip}";
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
