{...}: {
  sops.secrets = {
    home_assistant = {
      owner = "hass";
    };
    wireguard_mullvad = {
      owner = "vuetorrent";
      path = "/var/lib/vuetorrent/config/wireguard/wg0.conf";
    };
    df_password = {};
    cloudflare_dns_secret = {};
    harmonia_secret = {};
    mongo_init = {
      owner = "unifi";
    };
    mongo_secret = {
      owner = "unifi";
    };
  };
}
