{pkgs, ...}: let
  uid = 999;
  gid = 999;
  local-config-dir = "/nix/persist/cloudflared";
  app-name = "cloudflared";
  json = pkgs.formats.json {};
  network = import ../../../share/network.properties.nix;
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
    extraOptions = [
      "--ip=100.64.0.200"
      "--network=dmz-macvlan"
      "-l=io.containers.autoupdate=registry"
    ];
  };
  environment.etc."containers/networks/dmz-macvlan.json" = {
    source = json.generate "dmz-macvlan.json" {
      dns_enabled = false;
      driver = "macvlan";
      id = "1123000000000000000000000000000000000000000000000000000000000000";
      internal = false;
      ipam_options.driver = "host-local";
      ipv6_enabled = false;
      name = "dmz-macvlan";
      network_interface = "tailscale0";
      subnets = [
        {
          gateway = "100.64.0.1";
          subnet = "100.64.0.0/10";
        }
      ];
    };
  };
}
