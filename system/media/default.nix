{ config, pkgs, ... }:
let
  media = (import ./properties.nix).media;
in
{
  imports = [
    ./jellyfin.nix
    ./vuetorrent.nix
    ./jellyseerr.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
  ];
  systemd.tmpfiles.rules = [
    "d    ${media.dir.downloads}    -       -       -       -   - "
    "d    ${media.dir.movies}       -       -       -       -   - "
    "d    ${media.dir.tv}           -       -       -       -   - "
    "Z    /media                    770     media   media   -   - "
  ];
  users = {
    groups.media.gid = media.gid;
    users.media = {
      group = "media";
      uid = media.uid;
      isSystemUser = true;
    };
  };
}
