{...}: {
  users.users.raab.extraGroups = ["media" "syncthing"];
  # Sudo
  security.sudo.extraConfig = ''
    olivetin ALL=(root) NOPASSWD:/var/lib/olivetin/scripts/commands.sh
  '';
}
