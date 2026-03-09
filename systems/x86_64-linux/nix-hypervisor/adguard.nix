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
          enabled = true;
        }
        {
          domain = "${properties.network.domain}";
          answer = "${properties.network.nix-hypervisor.local.ip}";
          enabled = true;
        }
        {
          domain = "*.${properties.network.domain}";
          answer = "${properties.network.nix-hypervisor.local.ip}";
          enabled = true;
        }
      ];
    };
  };
  services.caddy.virtualHosts = {
    "adguard.${properties.network.domain}" = {
      useACMEHost = "${properties.network.domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy ${properties.network.nix-hypervisor.local.ip}:${toString properties.ports.adguard}
      '';
    };
  };
  services.gatus.settings.endpoints = [
    {
      name = "Adguard";
      url = "https://adguard.${properties.network.domain}/";
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
}
