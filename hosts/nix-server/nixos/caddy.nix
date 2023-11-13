{...}: let
  network = import ../../../share/network.properties.nix;
in {
  services.caddy = {
    enable = true;
    globalConfig = ''
      local_certs
    '';
  };
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "rob_lago@live.com";
      credentialsFile = "/var/lib/secrets/cloudflare.secret";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
    };
    certs.${network.domain}.domain = "*.${network.domain}";
  };
}
