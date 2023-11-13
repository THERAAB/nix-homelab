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
      webroot = "/var/lib/acme/acme-challenge";
      email = "rob_lago@live.com";
      credentialsFile = "/var/lib/secrets/cloudflare.secret";
      dnsProvider = "cloudflare";
    };
    certs.${network.domain}.domain = "pumpkin.rodeo";
  };
}
