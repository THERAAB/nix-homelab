{...}: {
  imports = [
    ../physical
  ];
  systemd.tmpfiles.rules = [
    "Z  /sync   770 syncthing   syncthing   -   - "
  ];
  sops.secrets.gatus_env.neededForUsers = true;
}
