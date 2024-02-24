{...}: let
  users = import ../../../share/users.properties.nix;
in {
  security.sudo.extraConfig = ''
    olivetin ALL=(root) NOPASSWD:/var/lib/olivetin/scripts/commands.sh
  '';
  users = {
    users = {
      nfsnobody = {
        uid = users.nfsnobody.uid; 
        group = "nfsnobody";
        extraGroups = ["media" "restic"];
        isSystemUser = true;
      };
    };
    groups = {
      nfsnobody = {};
      media.gid = users.media.gid;
      restic.gid = users.restic.gid;
    };
  };
}
