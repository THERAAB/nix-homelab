{properties, ...}: {
  nix-homelab.networking.adguard.enable = true;
  services.adguardhome = {
    host = properties.network.micro-infra.local.ip;
    settings = {
      dns.bind_hosts = [properties.network.micro-infra.local.ip];
      filtering.rewrites = [
        {
          domain = "pfsense.${properties.network.domain}";
          answer = "${properties.network.pfSense.local.ip}";
        }
        {
          domain = "${properties.network.domain}";
          answer = "${properties.network.micro-tailscale.local.ip}";
        }
        {
          domain = "*.${properties.network.domain}";
          answer = "${properties.network.micro-tailscale.local.ip}";
        }
      ];
    };
  };
}
