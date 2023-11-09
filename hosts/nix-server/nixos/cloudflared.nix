{...}: let
  network = import ../../../share/network.properties.nix;
in {
  services.cloudflared = {
    enable = true;
    tunnels."fe83e38e-87b3-4a77-9d4a-d808ff67178d" = {
      credentialsFile = "/home/raab/.cloudflared/fe83e38e-87b3-4a77-9d4a-d808ff67178d.json";
      default = "http_status:404";
      ingress = {
        "${network.domain}" = {
          service = "http://localhost:8082";
        };
      };
    };
  };
}
