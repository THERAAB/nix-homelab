{...}: {
  security.sudo.extraConfig = ''
    olivetin ALL=(root) NOPASSWD:/var/lib/olivetin/scripts/commands.sh
  '';
  users = {
    users = {
      raab.extraGroups = ["syncthing"];
      hass = {
        uid = 286;
        group = "hass";
        isSystemUser = true;
      };
    };
    groups.hass = {};
  };
}
