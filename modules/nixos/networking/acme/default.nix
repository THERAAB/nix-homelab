{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.networking.acme;
  secrets-dir = "/var/lib/secrets";
in {
  options.nix-homelab.networking.acme = with types; {
    enable = mkEnableOption (lib.mdDoc "System");
  };
  config = mkIf cfg.enable {
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
  };
}
