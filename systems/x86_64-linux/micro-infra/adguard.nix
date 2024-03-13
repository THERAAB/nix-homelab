{
  properties,
  self,
  ...
}: {
  imports = [
    (self + /share/optional/adguard.nix)
  ];
  services.adguardhome.settings = {
    bind_host = properties.network.micro-infra.local.ip;
    dns = {
      bind_hosts = [properties.network.micro-infra.local.ip];
      rewrites = [
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
