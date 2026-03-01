{properties, ...}: {
  nix-homelab.networking.adguard.enable = true;
  services.adguardhome = {
    host = properties.network.nix-hypervisor.local.ip;
    settings = {
      dns.bind_hosts = [properties.network.nix-hypervisor.local.ip];
      filtering.rewrites = [
        {
          domain = "pfsense.${properties.network.domain}";
          answer = "${properties.network.pfSense.local.ip}";
        }
        {
          domain = "${properties.network.domain}";
          answer = "${properties.network.nix-hypervisor.local.ip}";
        }
        {
          domain = "*.${properties.network.domain}";
          answer = "${properties.network.nix-hypervisor.local.ip}";
        }
      ];
    };
  };
}
