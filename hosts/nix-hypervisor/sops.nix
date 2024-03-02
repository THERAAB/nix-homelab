{...}: {
  systemd.tmpfiles.rules = [
    "L  /var/lib/microvms/micro-media/storage/run/secrets/cloudflare_dns_secret  -   -   -   -   /run/secrets/cloudflare_dns_secret   "
  ];
  sops.secrets = {
    home_assistant = {
      owner = "hass";
      path = "/var/lib/hass/secrets.yaml";
    };
    wireguard_mullvad = {
      owner = "vuetorrent";
      path = "/var/lib/microvms/micro-media/storage/var/lib/vuetorrent/wireguard/wg0.conf";
    };
    df_password = {};
    cloudflare_dns_secret = {};
    harmonia_secret = {};
    microbin_secret = {};
    mongo_init = {
      owner = "unifi";
      path = "/var/lib/microvms/micro-media/storage/var/lib/unifi/mongo_init";
    };
    mongo_secret = {
      owner = "unifi";
      path = "/var/lib/microvms/micro-media/storage/var/lib/unifi/mongo_secret";
    };
  };
}
