{...}: let
  network = import ../../share/network.properties.nix;
in {
  imports = [
    ../../share/optional/adguard.nix
  ];
  services.adguardhome.settings = {
    bind_host = network.micro-tailscale.local.ip;
    dns = {
      bind_hosts = [network.micro-tailscale.tailscale.ip network.micro-tailscale.local.ip];
      rewrites = [
        {
          domain = "${network.domain}";
          answer = "${network.micro-tailscale.tailscale.ip}";
        }
        {
          domain = "*.${network.domain}";
          answer = "${network.micro-tailscale.tailscale.ip}";
        }
      ];
    };
  };
}