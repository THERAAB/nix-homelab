{...}: let
  port = 8238;
  app-name = "gotify";
in {
  services.${app-name} = {
    enable = true;
    port = port;
  };
}
