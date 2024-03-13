{
  config,
  lib,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.media;
in {
  options.nix-homelab.media = with types; {
    enable = mkEnableOption (lib.mdDoc "Media");
  };
  config = mkIf cfg.enable {
    users = {
      users.root.extraGroups = ["media"];
      groups.media.gid = properties.media.group.id;
    };
    fileSystems = {
      "/media" = {
        device = "${properties.network.nix-nas.local.ip}:/nfs/media";
        fsType = "nfs";
        options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=1200"];
      };
    };
  };
}
