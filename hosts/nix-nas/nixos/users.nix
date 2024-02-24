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
        extraGroups = "";
        isSystemUser = true;
      };
    };
    groups = {
      nfsnobody = {};
      media = {
        id = users.media.gid;
      };
      restic = {
        id = users.restic.gid;
      };
    };
  };
}
