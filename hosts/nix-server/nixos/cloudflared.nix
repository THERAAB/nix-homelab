{...}: let
  network = import ../../../share/network.properties.nix;
in {
  services.cloudflared = {
    enable = true;
    tunnels."00000000-0000-0000-0000-000000000000" = {
      credentialsFile = "/nix/persist/cloudflared/file";
      default = "http_status:404";
      ingress = {
        "${network.domain}" = {
          service = "http://localhost:80";
        };
      };
    };
  };
}
