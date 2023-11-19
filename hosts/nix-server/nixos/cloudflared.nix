{config, ...}: let
  uid = 999;
  gid = 999;
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
  services.olivetin.settings.actions = [
    {
      title = "Stop Cloudflare";
      icon = ''<img src = "customIcons/${app-name}.png" width = "48px"/>'';
      shell = "sudo /var/lib/olivetin/scripts/commands.sh -x ${app-name}";
      timeout = 20;
    }
  ];
  virtualisation.oci-containers.containers."${app-name}" = {
    autoStart = true;
    image = "docker.io/cloudflare/${app-name}";
    user = "${toString uid}";
    environmentFiles = [
      config.sops.secrets.cloudflare_tunnel_secret.path
    ];
    cmd = [
      "tunnel"
      "--no-autoupdate"
      "run"
    ];
    extraOptions = [
      "-l=io.containers.autoupdate=registry"
    ];
  };
}
