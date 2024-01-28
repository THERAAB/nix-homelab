{...}: {
  users.users.raab.extraGroups = ["syncthing"];
  # Sudo
  security.sudo.extraConfig = ''
    olivetin ALL=(root) NOPASSWD:/var/lib/olivetin/scripts/commands.sh
  '';
}
