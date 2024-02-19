{...}: {
  sops.secrets = {
    home_assistant = {
      owner = "haas";
    };
    wireguard_mullvad = {};
    df_password = {};
    cloudflare_dns_secret = {};
    harmonia_secret = {};
    microbin_secret = {};
    mongo_init = {};
    mongo_secret = {};
  };
}
