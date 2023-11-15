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
      "--network=dmz-ipvlan"
      "--ip=${network.cloudflare.ip}"
      "-l=io.containers.autoupdate=registry"
    ];
  };
  environment.etc."containers/networks/dmz-ipvlan.json" = {
    source = json.generate "dmz-ipvlan.json" {
      dns_enabled = false;
      driver = "ipvlan";
      id = "1120000000000000000000000000000000000000000000000000000000000000";
      internal = false;
      ipam_options.driver = "host-local";
      ipv6_enabled = false;
      name = "dmz-ipvlan";
      network_interface = "enp3s0";
      subnets = [
        {
          gateway = "10.0.0.1";
          subnet = "${network.dmz.subnet}";
        }
      ];
    };
  };
}
