{
  lib,
  config,
  properties,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.jellyfin;
  uid = 9992;
  port = properties.ports.jellyfin;
  app-name = "jellyfin";
  local-config-dir = "/var/lib/${app-name}";
in {
  options.nix-homelab.wrappers.jellyfin = with types; {
    enable = mkEnableOption (lib.mdDoc "Jellyfin");
  };
  config = mkIf cfg.enable {
    users = {
      users."${app-name}" = {
        uid = uid;
        group = properties.media.group.name;
        isSystemUser = true;
      };
    };
    systemd = {
      tmpfiles.rules = [
        "d    ${local-config-dir}     -       -             -                               -   - "
        "Z    ${local-config-dir}     -       ${app-name}   ${properties.media.group.name}  -   - "
      ];
      services."podman-${app-name}".after = ["multi-user.target"]; # Delay jellyfin start for hardware encoding
    };
    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    virtualisation.oci-containers.containers."${app-name}" = {
      autoStart = true;
      image = "lscr.io/linuxserver/${app-name}";
      volumes = [
        "${local-config-dir}:/config"
        "${properties.media.dir.movies}:/movies"
        "${properties.media.dir.tv}:/tv"
      ];
      ports = ["${toString port}:8096"];
      environment = {
        PUID = "${toString uid}";
        PGID = "${toString properties.media.group.id}";
        UMASK = "022";
        TZ = "America/New_York";
        DOCKER_MODS = "linuxserver/mods:jellyfin-opencl-intel";
        JELLYFIN_PublishedServerUrl = "https://${app-name}.${properties.network.domain}";
      };
      extraOptions = [
        "--device=/dev/dri/renderD128:/dev/dri/renderD128"
        "--device=/dev/dri/card0:/dev/dri/card0"
        "-l=io.containers.autoupdate=registry"
      ];
    };
  };
}
