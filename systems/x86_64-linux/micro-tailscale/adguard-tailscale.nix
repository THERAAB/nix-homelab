{properties, ...}: {
  nix-homelab.networking.adguard.enable = true;
  services.adguardhome = {
    host = properties.network.micro-tailscale.local.ip;
    settings = {
      dns = {
        bind_hosts = [properties.network.micro-tailscale.tailscale.ip properties.network.micro-tailscale.local.ip];
        rewrites = [
          {
            domain = "pfsense.${properties.network.domain}";
            answer = "${properties.network.pfSense.local.ip}";
          }
          {
            domain = "${properties.network.domain}";
            answer = "${properties.network.micro-tailscale.tailscale.ip}";
          }
          {
            domain = "*.${properties.network.domain}";
            answer = "${properties.network.micro-tailscale.tailscale.ip}";
          }
        ];
      };
    };
  };
}
