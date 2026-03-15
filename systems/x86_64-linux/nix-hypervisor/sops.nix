{...}: {
  sops = {
    keepGenerations = 0;
    secrets = {
      home_assistant = {
        owner = "hass";
      };
      wireguard_mullvad = {
        owner = "vuetorrent";
      };
      df_password = {};
      cloudflare_dns_secret = {};
      harmonia_secret = {};
      mosquitto_password = {
        owner = "mosquitto";
      };
      govee2mqtt_env = {
        owner = "govee2mqtt";
      };
      linkwarden_nextauth = {
        owner = "linkwarden";
      };
      miniflux_admin = {
        owner = "linkwarden";
      };
      go2rtc_env = {};
    };
  };
}
