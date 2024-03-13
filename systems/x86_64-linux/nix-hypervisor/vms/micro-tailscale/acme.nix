{properties, ...}: let
  secrets-dir = "/var/lib/secrets";
in {
  systemd.tmpfiles.rules = [
    "d    ${secrets-dir}     -       -      -    -   - "
    "Z    ${secrets-dir}     644     root   -    -   - "
  ];
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "example@aol.com";
      credentialsFile = "/run/secrets/cloudflare_dns_secret";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:${toString properties.ports.dns}";
    };
    certs = {
      ${properties.network.domain}.domain = "*.${properties.network.domain}";
      "${properties.network.domain}-tld".domain = "${properties.network.domain}";
    };
  };
}
