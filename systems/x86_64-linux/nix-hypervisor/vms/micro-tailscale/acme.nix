{network, ports, ...}: let
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
      dnsResolver = "1.1.1.1:${toString ports.dns}";
    };
    certs = {
      ${network.domain}.domain = "*.${network.domain}";
      "${network.domain}-tld".domain = "${network.domain}";
    };
  };
}
