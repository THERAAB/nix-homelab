{pkgs, ...}: let
  uid = 999;
  gid = 999;
  local-config-dir = "/nix/persist/cloudflared";
  app-name = "cloudflared";
in {
  users = {
    users."${app-name}" = {
      uid = uid;
      group = app-name;
      isSystemUser = true;
    };
    groups.${app-name}.gid = gid;
  };
  systemd.tmpfiles.rules = [
    "Z  ${local-config-dir} 740 cloudflared cloudflared - - "
  ];
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "docker.io/cloudflare/${app-name}";
    user = "${toString uid}";
    environmentFiles = [
      "${local-config-dir}/env.secret"
    ];
    cmd = [
      "tunnel"
      "run"
    ];
  };
  environment.etc."containers/networks/cloudflare-network.json" = {
    source = pkgs.formats.json.generate "cloudflare-network.json" {
      dns_enabled = false;
      driver = "macvlan";
      id = "1100000000000000000000000000000000000000000000000000000000000000";
      internal = false;
      ipam_options = {driver = "host-local";};
      ipv6_enabled = false;
      name = "cloudflare-network";
      network_interface = "enp3s0";
      subnets = [
        {
          gateway = "10.0.0.1";
          subnet = "10.0.0.0/16";
        }
      ];
    };
  };
}
