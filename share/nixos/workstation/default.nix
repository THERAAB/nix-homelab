{...}: {
  imports = [
    ../physical
  ];
  systemd.tmpfiles.rules = [
    "Z  /sync   770 syncthing   syncthing   -   - "
  ];
  sops.secrets.gotify_homelab_token.neededForUsers = true;
}
