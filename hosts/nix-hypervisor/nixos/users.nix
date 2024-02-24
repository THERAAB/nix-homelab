{...}: let
  users = import ../../../share/users.properties.nix;
in {
  security.sudo.extraConfig = ''
    olivetin ALL=(root) NOPASSWD:/var/lib/olivetin/scripts/commands.sh
  '';
  users = {
    users = {
      raab.extraGroups = ["syncthing"];
      hass = {
        uid = users.hass.uid; 
        group = "hass";
        isSystemUser = true;
      };
      unifi = {
        uid = users.unifi.uid;
        group = "unifi";
        isSystemUser = true;
      };
      flatnotes = {
        uid = users.flatnotes.uid;
        group = "flatnotes";
        isSystemUser = true;
      };
      nfsnobody.extraGroups = ["restic" "media"];
    };
    groups = {
      hass = {};
      unifi = {};
      flatnotes = {};
    };
  };
}
