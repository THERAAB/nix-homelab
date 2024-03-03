{...}: let
  port = 8238;
  app-name = "gotify";
in {
  services.${app-name} = {
    enable = true;
    port = port;
  };
  environment = {
    GOTIFY_SERVER_SSL_ENABLED = false;
    GOTIFY_SERVER_SSL_REDIRECTTOHTTPS = false;
    GOTIFY_SERVER_SSL_LETSENCRYPT_ENABLED = false;
  };
}
