{
  config,
  properties,
  ...
}: {
  security.sudo.extraConfig = ''
    olivetin  ALL=(root)  NOPASSWD:/var/lib/olivetin/scripts/commands.sh
    raab      ALL=(root)  NOPASSWD:/run/current-system/sw/bin/flock -w 60 /dev/shm/nixinate-nix-hypervisor nixos-rebuild switch --flake /nix/store/[a-zA-Z0-9]*-source\#${config.networking.hostName}
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
