{...}: let
  network = import ../../share/network.properties.nix;
  secrets-dir = "/var/lib/secrets";
in {
  systemd.tmpfiles.rules = [
    "d    ${secrets-dir}     -       -      -    -   - "
    "Z    ${secrets-dir}     644     root   -    -   - "
  ];
  services.caddy = {
    enable = true;
    virtualHosts = {
      "vuetorrent.${network.domain}" = { #TODO: move to micro-server
        useACMEHost = "${network.domain}";
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${network.micro-media.local.ip}:8112
        '';
      };
    };
  };
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
