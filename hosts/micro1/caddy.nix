{...}: let
  network = import ../../../share/network.properties.nix;
  secrets-dir = "/var/lib/secrets";
in {
  systemd.tmpfiles.rules = [
    "d    ${secrets-dir}     -       -      -    -   - "
    "Z    ${secrets-dir}     644     root   -    -   - "
  ];
  services.caddy.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "example@aol.com";
      credentialsFile = "/run/secrets/cloudflare_dns_secret";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
    };
    certs = {
      ${network.domain}.domain = "*.${network.domain}";
      "${network.domain}-tld".domain = "${network.domain}";
    };
  };
}
