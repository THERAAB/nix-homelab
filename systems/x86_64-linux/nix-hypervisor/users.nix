{properties, ...}: {
  users = {
    users = {
      raab.extraGroups = ["syncthing" "media"];
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
    };
    groups = {
      hass = {};
      unifi = {};
    };
  };
}
