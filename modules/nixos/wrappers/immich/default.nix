{
  lib,
  config,
  properties,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.immich;
  port = properties.ports.immich;
  media-dir = "/sync/immich";
in {
  options.nix-homelab.wrappers.immich = with types; {
    enable = mkEnableOption (lib.mdDoc "Immich");
  };
  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d    ${media-dir}     -    -         -        -   - "
      "Z    ${media-dir}     -    immich   immich    -   - "
    ];
    services.immich = {
      enable = true;
      port = port;
      host = "0.0.0.0";
      openFirewall = true;
      accelerationDevices = ["/dev/dri/renderD128"];
      mediaLocation = media-dir;
    };
    users.users.immich.extraGroups = ["video" "render" "syncthing"];
  };
}
