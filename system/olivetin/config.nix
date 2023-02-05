{
  settings = {
    actions = [
      {
        title = "Reboot Server";
        icon = ''<img src = "customIcons/reboot.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -r";
        timeout = 20;
      }
      {
        title = "Restart Jellyfin";
        icon = ''<img src = "customIcons/jellyfin.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p jellyfin";
        timeout = 20;
      }
      {
        title = "Restart Jellyseerr";
        icon = ''<img src = "customIcons/jellyseerr.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p jellyseerr";
        timeout = 20;
      }
      {
        title = "Restart Home Assistant";
        icon = ''<img src = "customIcons/home-assistant.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -s home-assistant";
        timeout = 20;
      }
      {
        title = "Restart AdGuard";
        icon = ''<img src = "customIcons/adguard.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -s adguardhome";
        timeout = 20;
      }
      {
        title = "Restart Prowlarr";
        icon = ''<img src = "customIcons/prowlarr.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p prowlarr";
        timeout = 20;
      }
      {
        title = "Restart Radarr";
        icon = ''<img src = "customIcons/radarr.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p radarr";
        timeout = 20;
      }
    ];
  };
}