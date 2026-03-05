let
  network = import ../../../assets/properties/network.nix;
in {
  # See https://fontawesome.com/v5/search for icons options
  title = "Nix-Homelab";
  subtitle = "Services Dashboard";
  logo = "assets/icons/nixos.png";
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
      icon = "fas fa-envelope";
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
          logo = "assets/icons/jellyfin.png";
          subtitle = "Watch Movies & TV";
          tag = "media";
          keywords = "movies tv shows media";
          url = "https://jellyfin.${network.domain}";
          target = "_blank";
        }
        {
          name = "Jellyseerr";
          logo = "assets/icons/jellyseerr.png";
          subtitle = "Request Movies & TV";
          tag = "media";
          keywords = "movies tv shows media";
          url = "https://jellyseerr.${network.domain}";
          target = "_blank";
        }
        {
          name = "Audiobookshelf";
          logo = "assets/icons/audiobookshelf.png";
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
          logo = "assets/icons/gatus.png";
          subtitle = "Monitor Services";
          tag = "monitor";
          keywords = "monitor";
          url = "https://gatus.${network.domain}";
          target = "_blank";
        }
        {
          name = "Gotify";
          logo = "assets/icons/gotify.png";
          subtitle = "Send Notifications";
          tag = "notify";
          keywords = "notify alert";
          url = "https://gotify.${network.domain}";
          target = "_blank";
        }
        {
          name = "Netdata";
          logo = "assets/icons/netdata.png";
          subtitle = "Monitor Hardware";
          tag = "monitor";
          keywords = "monitor";
          url = "https://netdata.${network.domain}";
          target = "_blank";
        }
        {
          name = "Unifi Network Application";
          logo = "assets/icons/unifi.png";
          subtitle = "Wireless Access Point";
          tag = "wireless";
          keywords = "wireless router access point";
          url = "https://unifi.${network.domain}";
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
          logo = "assets/icons/home-assistant.png";
          subtitle = "Smart Home Automation";
          tag = "smart-home";
          keywords = "smart home assistant automation";
          url = "https://home-assistant.${network.domain}";
          target = "_blank";
        }
        {
          name = "Immich";
          logo = "assets/icons/immich.png";
          subtitle = "Photo Viewer & Backup";
          tag = "photo";
          keywords = "photo data media";
          url = "https://photos.${network.domain}";
          target = "_blank";
        }
        {
          name = "BentoPdf";
          logo = "assets/icons/bentopdf.png";
          subtitle = "PDF Editor";
          tag = "pdf";
          keywords = "pdf data media";
          url = "https://pdf.${network.domain}";
          target = "_blank";
        }
        {
          name = "SyncThing";
          logo = "assets/icons/syncthing.png";
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
          logo = "assets/icons/vuetorrent.png";
          subtitle = "Manage Torrents";
          tag = "download";
          keywords = "torrent download";
          url = "https://vuetorrent.${network.domain}";
          target = "_blank";
        }
        {
          name = "Radarr";
          logo = "assets/icons/radarr.png";
          subtitle = "Manage Movies";
          tag = "movies";
          keywords = "movies media";
          url = "https://movies.${network.domain}";
          target = "_blank";
        }
        {
          name = "Sonarr";
          logo = "assets/icons/sonarr.png";
          subtitle = "Manage TV Shows";
          tag = "tv";
          keywords = "tv shows media";
          url = "https://tv.${network.domain}";
          target = "_blank";
        }
        {
          name = "Flaresolverr";
          logo = "assets/icons/flaresolverr.png";
          subtitle = "Manage Cloudflare Challenges";
          tag = "cloudflare";
          keywords = "tv shows media";
          url = "https://flaresolverr.${network.domain}";
          target = "_blank";
        }
        {
          name = "Prowlarr";
          logo = "assets/icons/prowlarr.png";
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
          logo = "assets/icons/pfsense.png";
          subtitle = "Firewall Router";
          tag = "wireless";
          keywords = "router firewall";
          url = "https://pfsense.${network.domain}/";
          target = "_blank";
        }
        {
          name = "AdGuard Local";
          logo = "assets/icons/adguard.png";
          subtitle = "Local Network DNS Server";
          tag = "dns";
          keywords = "dns adblock";
          url = "https://adguard.${network.domain}";
          target = "_blank";
        }
        {
          name = "AdGuard Tailscale";
          logo = "assets/icons/tailscale.png";
          subtitle = "Tailscale DNS Server";
          tag = "dns";
          keywords = "dns adblock";
          url = "https://adguard-tailscale.${network.domain}";
          target = "_blank";
        }
      ];
    }
  ];
}
