{ config, pkgs, ... }:
{
  home.persistence."/nix/persist/home/raab" = {
    allowOther = true;
    directories = [
      ".ssh" # Git
      ".config/sops/age"
    ];
    files = [
      ".config/.gitconfig"
    ];
  };
}
