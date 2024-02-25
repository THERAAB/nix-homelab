{...}: let
  media = import ./media.properties.nix;
in {
  users = {
    users.root.extraGroups = ["media"];
    groups.media.gid = media.group.id;
  };
}
