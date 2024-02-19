{...}: {
  sops.secrets = {
    home_assistant.owner = "hass";
    wireguard_mullvad = {};
    df_password = {};
    cloudflare_dns_secret = {};
    harmonia_secret = {};
    microbin_secret = {};
    mongo_init.owner = "unifi";
    mongo_secret.owner = "unifi";
  };
}
