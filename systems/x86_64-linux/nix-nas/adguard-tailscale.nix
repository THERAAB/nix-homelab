{properties, ...}: {
  nix-homelab.networking.adguard.enable = true;
  services.adguardhome = {
    host = properties.network.nix-nas.local.ip;
    settings = {
      dns.bind_hosts = [properties.nix-nas.tailscale.ip properties.network.nix-nas.local.ip];
      filtering.rewrites = [
        {
          domain = "pfsense.${properties.network.domain}";
          answer = "${properties.network.pfSense.local.ip}";
          enabled = true;
        }
        {
          domain = "${properties.network.domain}";
          answer = "${properties.network.nix-hypervisor.tailscale.ip}";
          enabled = true;
        }
        {
          domain = "*.${properties.network.domain}";
          answer = "${properties.network.nix-hypervisor.tailscale.ip}";
          enabled = true;
        }
      ];
    };
  };
}
