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
      mongo_init = {
        owner = "unifi";
      };
      mongo_secret = {
        owner = "unifi";
      };
    };
  };
}
