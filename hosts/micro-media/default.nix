{...}:
let
media = import ./media.properties;
in 
 {
  imports = [
    ./adguard
    ./system.nix
    ./nfs.nix
    ./caddy.nix
    ./jellyfin.nix
    ./vuetorrent.nix
    ./jellyseerr.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./audiobookshelf.nix
    ./readarr.nix
  ];
  users.groups.media.gid = media.group.id;
}
