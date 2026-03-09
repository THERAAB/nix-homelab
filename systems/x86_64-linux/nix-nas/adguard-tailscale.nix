{properties, ...}: {
  nix-homelab.networking.adguard.enable = true;
  services.caddy.virtualHosts = {
    "adguard-tailscale.${properties.network.domain}" = {
      useACMEHost = "${properties.network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy ${properties.network.nix-nas.local.ip}:${toString properties.ports.adguard}
      '';
    };
  };
  services.gatus.settings.endpoints = [
    {
      name = "Adguard Tailscale";
      url = "https://adguard-tailscale.${properties.network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>Login</title>*)''
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
  ];
  services.adguardhome = {
    host = properties.network.nix-nas.local.ip;
    settings = {
      dns.bind_hosts = [properties.network.nix-nas.tailscale.ip properties.network.nix-nas.local.ip];
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
