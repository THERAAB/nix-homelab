{...}: let
  users = import ../../users.properties.nix;
in {
  users = {
    groups = {
      media.gid = users.media.gid;
      restic.gid = 11202;
    };
  };
}
