{...}: {
  users.users.raab.extraGroups = ["media" "homer"];
  # Sudo
  security.sudo.extraConfig = ''
    olivetin ALL=(root) NOPASSWD:/var/lib/olivetin/scripts/commands.sh
  '';
}
