{properties, ...}: {
  security.sudo.extraConfig = ''
    olivetin  ALL=(root)  NOPASSWD:/var/lib/olivetin/scripts/commands.sh
  '';
  users = {
    users = {
      raab.extraGroups = ["syncthing"];
      hass = {
        uid = properties.users.hass.uid;
        group = "hass";
        isSystemUser = true;
      };
      unifi = {
        uid = properties.users.unifi.uid;
        group = "unifi";
        isSystemUser = true;
      };
      flatnotes = {
        uid = properties.users.flatnotes.uid;
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
