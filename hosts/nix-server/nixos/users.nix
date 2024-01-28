{...}: {
  users.users.raab.extraGroups = ["syncthing"];
  users.users.root.extraGroups = ["syncthing" "photoprism"];
  # Sudo
  security.sudo.extraConfig = ''
    olivetin ALL=(root) NOPASSWD:/var/lib/olivetin/scripts/commands.sh
  '';
}
