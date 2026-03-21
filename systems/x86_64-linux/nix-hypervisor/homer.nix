{properties, ...}: let
  network = properties.network;
  github-icons-dir = "https://github.com/THERAAB/nix-homelab/blob/main/assets/icons";
in {
  services.homer.settings = {
    # See https://fontawesome.com/v5/search for icons options
    title = "Nix-Homelab";
    subtitle = "Services Dashboard";
    logo = github-icons-dir + "/nixos.png?raw=true";
    header = true;
    footer = false;
    theme = "walkxcode";
    links = [
      {
        name = "GitHub";
        icon = "fab fa-github";
        url = "https://github.com/";
        target = "_blank";
      }
      {
        name = "Tailscale";
        icon = "fas fa-grip-horizontal";
        url = "https://login.tailscale.com";
        target = "_blank";
      }
      {
        name = "YouTube";
        icon = "fab fa-youtube";
        url = "https://www.youtube.com/";
        target = "_blank";
      }
      {
        name = "Gmail";
        icon = "fas fa-envelope-open-text";
        url = "https://mail.google.com/mail/u/0/#inbox";
        target = "_blank";
      }
      {
        name = "Outlook";
        icon = "fas fa-at";
        url = "https://outlook.live.com/mail/0/";
        target = "_blank";
      }
    ];
    services = [
      {
        name = "Media";
        icon = "fas fa-ticket";
        items = [
          {
            name = "Jellyfin";
            logo = github-icons-dir + "/jellyfin.png?raw=true";
            subtitle = "Watch Movies & TV";
            tag = "media";
            keywords = "movies tv shows media";
            url = "https://jellyfin.${network.domain}";
            target = "_blank";
          }
          {
            name = "Seerr";
            logo = github-icons-dir + "/seerr.png?raw=true";
            subtitle = "Request Movies & TV";
            tag = "media";
            keywords = "movies tv shows media";
            url = "https://jellyseerr.${network.domain}";
            target = "_blank";
          }
          {
            name = "Immich";
            logo = github-icons-dir + "/immich.png?raw=true";
            subtitle = "Photo Viewer & Backup";
            tag = "photo";
            keywords = "photo data media";
            url = "https://photos.${network.domain}";
            target = "_blank";
          }
          {
            name = "Miniflux";
            logo = github-icons-dir + "/miniflux.png?raw=true";
            subtitle = "RSS Reader";
            tag = "rss";
            keywords = "rss data media";
            url = "https://rss.${network.domain}";
            target = "_blank";
          }
          {
            name = "Audiobookshelf";
            logo = github-icons-dir + "/audiobookshelf.png?raw=true";
            subtitle = "Listen to Audiobooks and Podcasts";
            tag = "audiobook";
            keywords = "audiobook podcast media";
            url = "https://audiobooks.${network.domain}";
            target = "_blank";
          }
        ];
      }
      {
        name = "Monitoring";
        icon = "fas fa-chart-area";
        items = [
          {
            name = "Gatus";
            logo = github-icons-dir + "/gatus.png?raw=true";
            subtitle = "Monitor Services";
            tag = "monitor";
            keywords = "monitor";
            url = "https://gatus.${network.domain}";
            target = "_blank";
          }
          {
            name = "Gotify";
            logo = github-icons-dir + "/gotify.png?raw=true";
            subtitle = "Send Notifications";
            tag = "notify";
            keywords = "notify alert";
            url = "https://gotify.${network.domain}";
            target = "_blank";
          }
          {
            name = "Netdata";
            logo = github-icons-dir + "/netdata.png?raw=true";
            subtitle = "Monitor Hardware";
            tag = "monitor";
            keywords = "monitor";
            url = "https://netdata.${network.domain}";
            target = "_blank";
          }
          {
            name = "Beszel";
            logo = github-icons-dir + "/beszel.png?raw=true";
            subtitle = "Monitor Hardware";
            tag = "monitor";
            keywords = "monitor";
            url = "https://beszel.${network.domain}";
            target = "_blank";
          }
          {
            name = "Backrest";
            logo = github-icons-dir + "/backrest.png?raw=true";
            subtitle = "Restic Backups GUI";
            tag = "backup";
            keywords = "backup";
            url = "https://restic.${network.domain}";
            target = "_blank";
          }
          {
            name = "OliveTin";
            logo = github-icons-dir + "/olivetin.png?raw=true";
            subtitle = "Execute Commands";
            tag = "exec";
            keywords = "exec";
            url = "https://olivetin.${network.domain}";
            target = "_blank";
          }
        ];
      }
      {
        name = "Appliances";
        icon = "fas fa-calculator";
        items = [
          {
            name = "Home Assistant";
            logo = github-icons-dir + "/home-assistant.png?raw=true";
            subtitle = "Smart Home Automation";
            tag = "smart-home";
            keywords = "smart home assistant automation";
            url = "https://home-assistant.${network.domain}";
            target = "_blank";
          }
          {
            name = "BentoPdf";
            logo = github-icons-dir + "/bentopdf.png?raw=true";
            subtitle = "PDF Editor";
            tag = "pdf";
            keywords = "pdf data media";
            url = "https://pdf.${network.domain}";
            target = "_blank";
          }
          {
            name = "Linkwarden";
            logo = github-icons-dir + "/linkwarden.png?raw=true";
            subtitle = "Bookmark storage";
            tag = "bookmarks";
            keywords = "bookmarks links save";
            url = "https://bookmarks.${network.domain}";
            target = "_blank";
          }
          {
            name = "Microbin";
            logo = github-icons-dir + "/microbin.png?raw=true";
            subtitle = "Pastebin";
            tag = "pastebin";
            keywords = "pastebin";
            url = "https://microbin.${network.domain}";
            target = "_blank";
          }
          {
            name = "SyncThing";
            logo = github-icons-dir + "/syncthing.png?raw=true";
            subtitle = "Shared Data & Folders";
            tag = "sync";
            keywords = "sync backup share data media";
            url = "https://sync.${network.domain}";
            target = "_blank";
          }
        ];
      }
      {
        name = "Download";
        icon = "fas fa-cloud-download-alt";
        items = [
          {
            name = "VueTorrent";
            logo = github-icons-dir + "/vuetorrent.png?raw=true";
            subtitle = "Manage Torrents";
            tag = "download";
            keywords = "torrent download";
            url = "https://vuetorrent.${network.domain}";
            target = "_blank";
          }
          {
            name = "Radarr";
            logo = github-icons-dir + "/radarr.png?raw=true";
            subtitle = "Manage Movies";
            tag = "movies";
            keywords = "movies media";
            url = "https://movies.${network.domain}";
            target = "_blank";
          }
          {
            name = "Sonarr";
            logo = github-icons-dir + "/sonarr.png?raw=true";
            subtitle = "Manage TV Shows";
            tag = "tv";
            keywords = "tv shows media";
            url = "https://tv.${network.domain}";
            target = "_blank";
          }
          {
            name = "Flaresolverr";
            logo = github-icons-dir + "/flaresolverr.png?raw=true";
            subtitle = "Manage Cloudflare Challenges";
            tag = "cloudflare";
            keywords = "tv shows media";
            url = "https://flaresolverr.${network.domain}";
            target = "_blank";
          }
          {
            name = "Prowlarr";
            logo = github-icons-dir + "/prowlarr.png?raw=true";
            subtitle = "Manage Indexers";
            tag = "media";
            keywords = "indexer media torrent download";
            url = "https://prowlarr.${network.domain}";
            target = "_blank";
          }
        ];
      }
      {
        name = "Networking";
        icon = "fas fa-network-wired";
        items = [
          {
            name = "PfSense";
            logo = github-icons-dir + "/pfsense.png?raw=true";
            subtitle = "Firewall Router";
            tag = "wireless";
            keywords = "router firewall";
            url = "https://pfsense.${network.domain}/";
            target = "_blank";
          }
          {
            name = "AdGuard Local";
            logo = github-icons-dir + "/adguard.png?raw=true";
            subtitle = "Local Network DNS Server";
            tag = "dns";
            keywords = "dns adblock";
            url = "https://adguard.${network.domain}";
            target = "_blank";
          }
          {
            name = "AdGuard Tailscale";
            logo = github-icons-dir + "/tailscale.png?raw=true";
            subtitle = "Tailscale DNS Server";
            tag = "dns";
            keywords = "dns adblock";
            url = "https://adguard-tailscale.${network.domain}";
            target = "_blank";
          }
          {
            name = "Unifi Network Application";
            logo = github-icons-dir + "/unifi.png?raw=true";
            subtitle = "Wireless Access Point";
            tag = "wireless";
            keywords = "wireless router access point";
            url = "https://unifi.${network.domain}";
            target = "_blank";
          }
        ];
      }
    ];
  };
}
