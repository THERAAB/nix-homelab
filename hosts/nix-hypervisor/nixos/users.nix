{...}: {
  security.sudo.extraConfig = ''
    olivetin ALL=(root) NOPASSWD:/var/lib/olivetin/scripts/commands.sh
  '';
  users = {
    users = {
      raab.extraGroups = ["syncthing"];
      hass = {
        uid = 286; #TODO: move to share
        group = "hass";
        isSystemUser = true;
      };
      unifi = {
        uid = 7812;
        group = "unifi";
        isSystemUser = true;
      };
      flatnotes = {
        uid = 7762;
        group = "flatnotes";
        isSystemUser = true;
      };
    };
    groups = {
      hass = {};
      unifi = {};
      flatnotes = {};
    };
  };
}
