{inputs, ...}: let
  media-dir = "/nfs/media";
  users = import (inputs.self + /assets/properties/users.properties.nix);
in {
  systemd.tmpfiles.rules = [
    "d    ${media-dir}/downloads    -       -       -       -   - "
    "d    ${media-dir}/movies       -       -       -       -   - "
    "d    ${media-dir}/tv           -       -       -       -   - "
    "d    ${media-dir}/audiobooks   -       -       -       -   - "
    "d    ${media-dir}/podcasts     -       -       -       -   - "
  ];
  users.groups.media.gid = users.media.gid;
}
