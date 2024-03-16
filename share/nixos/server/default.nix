{...}: {
  imports = [
    ../physical
  ];
  environment.persistence."/nix/persist/system" = {
    directories = [
      "/var/cache/netdata"
      "/var/www/"
    ];
  };
  sops.secrets = {
    gotify_gatus_token = {};
    restic_password = {};
    netdata_alarm = {};
  };
}
