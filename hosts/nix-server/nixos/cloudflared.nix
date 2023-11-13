{...}: let
  network = import ../../../share/network.properties.nix;
  local-config-dir = "/nix/persist/cloudflared";
in {
  systemd.tmpfiles.rules = [
    "Z  ${local-config-dir} 740 cloudflared cloudflared - - "
  ];
  services.cloudflared = {
    enable = true;
    tunnels."efedc805-364b-4ea1-adb1-7b85b3dd417c" = {
      credentialsFile = "${local-config-dir}/efedc805-364b-4ea1-adb1-7b85b3dd417c.json";
      default = "http_status:404";
      # originRequest.noTLSVerify = true;
      ingress = {
        "${network.domain}" = {
          service = "http://localhost:8082";
        };
      };
    };
  };
  environment.sessionVariables.TUNNEL_ORIGIN_CERT = "${local-config-dir}/cert.pem";
}
