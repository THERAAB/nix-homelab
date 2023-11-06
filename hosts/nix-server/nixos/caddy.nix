{...}: {
  services.caddy = {
    enable = true;
    globalConfig = ''
      local_certs
      auto_https disable_redirects
    '';
  };
}
