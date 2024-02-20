{...}: {
  sops.secrets = {
    home_assistant = {
      owner = "hass";
      path = "/var/lib/hass/secrets.yaml";
    };
    wireguard_mullvad = {};
    df_password = {};
    cloudflare_dns_secret = {};
    harmonia_secret = {};
    microbin_secret = {};
    mongo_init = {
      owner = "unifi";
      path = "/var/lib/unifi/mongo_init";
    };
    mongo_secret = {
      owner = "unifi";
      path = "/var/lib/unifi/mongo_secret";
    };
  };
}
