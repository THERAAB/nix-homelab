{
  # See https://fontawesome.com/v5/search for icons options
  title = "Nix Homelab Server";
  subtitle = "Homer.tail Dashboard";
  logo = "logo.png";
  header = true;
  footer = false;
  theme = "default";
  colors = {
    light = {
      highlight-primary = "#eceff4";
      highlight-secondary = "#e5e9f0";
      highlight-hover = "#d8dee9";
      background = "#e5e9f0";
      card-background = "#eceff4";
      text = "#30576d";
      text-header = "#30576d";
      text-title = "#434c5e";
      text-subtitle = "#4c566a";
      card-shadow = "rgba(0, 0, 0, 0.1)";
    };
    dark = {
      highlight-primary = "#323946";
      highlight-secondary = "#323946";
      highlight-hover = "#323946";
      background = "#2E3440";
      card-background = "#3b4252";
      text = "#81A1C1";
      text-header = "#81A1C1";
      text-title = "#D8DEE9";
      text-subtitle = "#ECEFF4";
      card-shadow = "rgba(0, 0, 0, 0.4)";
    };
  };
  links = [
    {
      name = "GitHub";
      icon = "fab fa-github";
      url = "https://github.com/THERAAB/nix-homelab";
    }
    {
      name = "Wiki";
      icon = "fas fa-book";
      url = "https://www.wikipedia.org/";
    }
  ];
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
          url = "http://jellyfin.server.tail";
        }
        {
         name = "Jellyseerr";
          logo = "assets/icons/jellyseerr.png";
          subtitle = "Request Movies & TV";
          tag = "media";
          keywords = "movies tv shows media";
          url = "http://jellyseerr.server.tail";
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
          url = "http://prowlarr.server.tail";
        }
        {
          name = "VueTorrent";
          logo = "assets/icons/vuetorrent.png";
          subtitle = "Manage Torrents";
          tag = "download";
          keywords = "torrent download";
          url = "http://vuetorrent.server.tail";
        }
        {
          name = "Radarr";
          logo = "assets/icons/radarr.png";
          subtitle = "Manage Movies";
          tag = "movies";
          keywords = "movies media";
          url = "http://radarr.server.tail";
        }
        {
          name = "Sonarr";
          logo = "assets/icons/sonarr.png";
          subtitle = "Manage TV Shows";
          tag = "tv";
          keywords = "tv shows media";
          url = "http://sonarr.server.tail";
        }
      ];
    }
    {
      name = "Devices";
      icon = "fas fa-house-signal";
      items = [
        {
          name = "TP-Link Archer";
          logo = "assets/icons/tplink.png";
          subtitle = "Wireless Access Point";
          tag = "wireless";
          keywords = "wireless router access point";
          url = "http://tplink.server.tail";
        }
        {
          name = "AdGuard";
          logo = "assets/icons/adguard.png";
          subtitle = "DNS Ad Blocking";
          tag = "dns";
          keywords = "dns adblock";
          url = "http://adguard.server.tail";
        }
        {
          name = "Home Assistant";
          logo = "assets/icons/home-assistant.png";
          subtitle = "Smart Home Automation";
          tag = "smart-home";
          keywords = "smart home assistant automation";
          url = "http://home-assistant.server.tail";
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
          url = "http://netdata.server.tail";
        }
        {
          name = "Gatus";
          logo = "assets/icons/gatus.png";
          subtitle = "Monitor Services";
          tag = "monitor";
          keywords = "monitor";
          url = "http://gatus.server.tail";
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
          url = "http://olivetin.server.tail";
        }
      ];
    }
  ];
}