{...}: {
  users.users.raab.extraGroups = ["syncthing"];
  security.sudo.extraConfig = ''
    olivetin ALL=(root) NOPASSWD:/var/lib/olivetin/scripts/commands.sh
  '';
}
