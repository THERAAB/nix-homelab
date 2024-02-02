{...}: {
  sops.secrets = {
    #home_assistant = {
    #  owner = "hass";
    #  path = "/var/lib/hass/secrets.yaml";
    #};
    wireguard_mullvad = {
      owner = "vuetorrent";
    };
    df_password = {};
    cloudflare_dns_secret = {};
    harmonia_secret = {};
    microbin_secret = {};
    mongo_init.owner = "unifi";
    mongo_secret.owner = "unifi";
  };
}
