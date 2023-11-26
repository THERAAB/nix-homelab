let
  settings-default = import ./settings-default.nix;
  network = import ../../../../share/network.properties.nix;
in {
  # See https://fontawesome.com/v5/search for icons options
  title = settings-default.title;
  subtitle = "Homer Dashboard";
  logo = settings-default.logo;
  header = settings-default.header;
  footer = settings-default.footer;
  theme = settings-default.theme;
  colors = settings-default.colors;
  links = settings-default.links;
  services = [
    {
      name = "Media";
      icon = "fas fa-play";
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
          url = "https://audiobookshelf.${network.domain}";
          target = "_blank";
        }
        {
          name = "SyncThing";
          logo = "assets/icons/syncthing.png";
          subtitle = "Shared Data & Folders";
          tag = "sync";
          keywords = "sync backup share data media";
          url = "https://syncthing.${network.domain}";
          target = "_blank";
        }
        {
          name = "Photoprism";
          logo = "assets/icons/photoprism.png";
          subtitle = "View & Manage Photos";
          tag = "photos";
          keywords = "photos media";
          url = "https://photoprism.${network.domain}";
          target = "_blank";
        }
      ];
    }
    {
      name = "Downloads";
      icon = "fas fa-download";
      items = [
        {
          name = "Prowlarr";
          logo = "assets/icons/prowlarr.png";
          subtitle = "Manage Indexers";
          tag = "media";
          keywords = "indexer media torrent download";
          url = "https://prowlarr.${network.domain}";
          target = "_blank";
        }
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
          url = "https://radarr.${network.domain}";
          target = "_blank";
        }
        {
          name = "Sonarr";
          logo = "assets/icons/sonarr.png";
          subtitle = "Manage TV Shows";
          tag = "tv";
          keywords = "tv shows media";
          url = "https://sonarr.${network.domain}";
          target = "_blank";
        }
        {
          name = "Readarr";
          logo = "assets/icons/readarr.png";
          subtitle = "Manage Books";
          tag = "books";
          keywords = "books audiobooks media";
          url = "https://readarr.${network.domain}";
          target = "_blank";
        }
      ];
    }
    {
      name = "Devices";
      icon = "fas fa-house-signal";
      items = [
        {
          name = "PfSense";
          logo = "assets/icons/pfsense.png";
          subtitle = "Firewall Router";
          tag = "wireless";
          keywords = "router firewall";
          url = "https://pfsense.pumpkin/";
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
        {
          name = "AdGuard";
          logo = "assets/icons/adguard.png";
          subtitle = "DNS Ad Blocking";
          tag = "dns";
          keywords = "dns adblock";
          url = "https://adguard.${network.domain}";
          target = "_blank";
        }
        {
          name = "Home Assistant";
          logo = "assets/icons/home-assistant.png";
          subtitle = "Smart Home Automation";
          tag = "smart-home";
          keywords = "smart home assistant automation";
          url = "https://home-assistant.${network.domain}";
          target = "_blank";
        }
      ];
    }
    {
      name = "Monitoring";
      icon = "fas fa-chart-area";
      items = [
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
          name = "Gatus";
          logo = "assets/icons/gatus.png";
          subtitle = "Monitor Services";
          tag = "monitor";
          keywords = "monitor";
          url = "https://gatus.${network.domain}";
          target = "_blank";
        }
      ];
    }
    {
      name = "Maintenance";
      icon = "fas fa-cogs";
      items = [
        {
          name = "OliveTin";
          logo = "assets/icons/olivetin.png";
          subtitle = "Execute Commands";
          tag = "exec";
          keywords = "exec";
          url = "https://olivetin.${network.domain}";
          target = "_blank";
        }
      ];
    }
  ];
}
