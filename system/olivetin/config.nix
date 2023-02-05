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
      {
        title = "Restart Sonarr";
        icon = ''<img src = "customIcons/sonarr.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p sonarr";
        timeout = 20;
      }
      {
        title = "Restart Vuetorrent";
        icon = ''<img src = "customIcons/vuetorrent.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p vuetorrent";
        timeout = 20;
      }
      {
        title = "Restart NetData";
        icon = ''<img src = "customIcons/netdata.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -s netdata";
        timeout = 20;
      }
      {
        title = "Restart Gatus";
        icon = ''<img src = "customIcons/gatus.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p gatus";
        timeout = 20;
      }
      {
        title = "Restart Homer.box";
        icon = ''<img src = "customIcons/pwa-192x192.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p homer.box";
        timeout = 20;
      }
      {
        title = "Restart Homer.tail";
        icon = ''<img src = "customIcons/pwa-192x192.png" width = "48px"/>'';
        shell = "sudo /nix/persist/olivetin/scripts/commands.sh -p homer.tail";
        timeout = 20;
      }
    ];
  };
}