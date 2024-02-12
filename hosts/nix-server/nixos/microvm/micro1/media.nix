{...}: let
  media-dir = "/media";
in {
  systemd.tmpfiles.rules = [
    "d    ${media-dir}/downloads    -       -       -       -   - "
    "d    ${media-dir}/movies       -       -       -       -   - "
    "d    ${media-dir}/tv           -       -       -       -   - "
    "d    ${media-dir}/audiobooks   -       -       -       -   - "
    "d    ${media-dir}/podcasts     -       -       -       -   - "
  ];
}
