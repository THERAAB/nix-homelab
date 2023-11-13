{...}: let
  network = import ../../../share/network.properties.nix;
in {
  services.caddy = {
    enable = true;
    globalConfig = ''
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
    certs."${network.domain}-test".domain = "test.${network.domain}";
    certs."${network.domain}-tld".domain = "${network.domain}";
  };
}
