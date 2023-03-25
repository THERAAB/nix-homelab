{ config, pkgs, ... }:
{
  home.persistence."/nix/persist/home/raab" = {
    allowOther = true;
    directories = [
      ".config/sops/age"
    ];
    files = [
      ".ssh/known_hosts"
      ".ssh/id_rsa"
    ];
  };
}
