{...}: {
  security.sudo.extraConfig = ''
    olivetin ALL=(root) NOPASSWD:/var/lib/olivetin/scripts/commands.sh
  '';
  users.groups.media.gid = 11201;
  users.users."hass" = {
    uid = 286;
    isSystemUser = true;
  };
}
