{ config, pkgs, ... }:
{     
  users.users.raab.extraGroups = [ "media" "homer" ];
  # Sudo
  security.sudo.extraConfig = ''
    olivetin ALL=(root) NOPASSWD:/nix/persist/olivetin/scripts/commands.sh
  '';
}
