{...}: let
  network = import ../../share/network.properties.nix;
in {
  imports = [
    ../../share/optional/adguard.nix
  ];
  services.adguardhome.settings = {
    bind_host = network.micro-utils.local.ip;
    dns = {
      bind_hosts = [network.micro-utils.local.ip];
      rewrites = [
        {
          domain = "pfsense.${network.domain}";
          answer = "${network.pfsense.local.ip}";
        }
        {
          domain = "${network.domain}";
          answer = "${network.micro-tailscale.local.ip}";
        }
        {
          domain = "*.${network.domain}";
          answer = "${network.micro-tailscale.local.ip}";
        }
      ];
    };
  };
}
