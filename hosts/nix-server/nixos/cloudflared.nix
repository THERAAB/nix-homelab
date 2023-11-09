{...}: let
  network = import ../../../share/network.properties.nix;
  local-config-dir = "/nix/persist/cloudflared";
in {
  systemd.tmpfiles.rules = [
    "Z  ${local-config-dir} 740 cloudflared cloudflared - - "
  ];
  services.cloudflared = {
    enable = true;
    tunnels."fe83e38e-87b3-4a77-9d4a-d808ff67178d" = {
      credentialsFile = "${local-config-dir}/fe83e38e-87b3-4a77-9d4a-d808ff67178d.json";
      default = "http_status:404";
      ingress = {
        "${network.domain}" = {
          service = "http://localhost:8082";
        };
      };
    };
  };
}
