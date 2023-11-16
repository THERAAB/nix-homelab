{pkgs, ...}: let
  media = import ./media.properties.nix;
  json = pkgs.formats.json {};
in {
  imports = [
    ./jellyfin.nix
    ./vuetorrent.nix
    ./jellyseerr.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./audiobookshelf.nix
    ./readarr.nix
  ];
  systemd.tmpfiles.rules = [
    "d    ${media.dir.downloads}    -       -       -       -   - "
    "d    ${media.dir.movies}       -       -       -       -   - "
    "d    ${media.dir.tv}           -       -       -       -   - "
    "d    ${media.dir.audiobooks}   -       -       -       -   - "
    "d    ${media.dir.podcasts}     -       -       -       -   - "
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
  environment.etc."containers/networks/media-network.json" = {
    source = json.generate "media-network.json" {
      dns_enabled = true;
      driver = "bridge";
      id = "5d72ec37e6860f72e48285f65f3e1bad7e5933cb939426e4ad6874200339353a";
      internal = false;
      ipam_options.driver = "host-local";
      ipv6_enabled = false;
      name = "media-network";
      network_interface = "podman2";
      subnets = [
        {
          gateway = "10.99.0.1";
          subnet = "10.99.0.0/24";
        }
      ];
    };
  };
}
