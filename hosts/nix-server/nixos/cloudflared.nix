{
  config,
  pkgs,
  ...
}: let
  uid = 999;
  gid = 999;
  app-name = "cloudflared";
  json = pkgs.formats.json {};
in {
  users = {
    users."${app-name}" = {
      uid = uid;
      group = app-name;
      isSystemUser = true;
    };
    groups.${app-name}.gid = gid;
  };
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "docker.io/cloudflare/${app-name}";
    user = "${toString uid}";
    environmentFiles = [
      "${toString config.sops.secrets.cloudflare_secret.path}"
    ];
    cmd = [
      "tunnel"
      "run"
      # "homepage"
    ];
    extraOptions = [
      "--network=cloudflare-network"
      "-l=io.containers.autoupdate=registry"
    ];
  };
  environment.etc."containers/networks/cloudflare-network.json" = {
    source = json.generate "cloudflare-network.json" {
      dns_enabled = true;
      driver = "bridge";
      id = "dd72ec37e6860f72e48285f65f3e1bad7e5933cb939426e4ad6874200339353a";
      internal = false;
      ipam_options.driver = "host-local";
      ipv6_enabled = false;
      name = "cloudflare-network";
      network_interface = "podman3";
      subnets = [
        {
          gateway = "10.94.0.1";
          subnet = "10.94.0.0/24";
        }
      ];
    };
  };
}
