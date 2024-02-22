{...}:
let
media = import ./media.properties.nix;
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
    ./microvm.nix
  ];
  users.groups.media.gid = media.group.id;
}
