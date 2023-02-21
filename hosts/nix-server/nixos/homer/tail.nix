let
  settings-default = import ./settings-default.nix;
  network = import ../../../../share/network.properties.nix;
in
{
  # See https://fontawesome.com/v5/search for icons options
  title = settings-default.title;
  subtitle = "Homer.tail Dashboard";
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
          logo = "share/assets/icons/jellyfin.png";
          subtitle = "Watch Movies & TV";
          tag = "media";
          keywords = "movies tv shows media";
          url = "http://jellyfin.${network.domain.tail}";
          target = "_blank";
        }
        {
          name = "Jellyseerr";
          logo = "share/assets/icons/jellyseerr.png";
          subtitle = "Request Movies & TV";
          tag = "media";
          keywords = "movies tv shows media";
          url = "http://jellyseerr.${network.domain.tail}";
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
          logo = "share/assets/icons/prowlarr.png";
          subtitle = "Manage Indexers";
          tag = "media";
          keywords = "indexer media torrent download";
          url = "http://prowlarr.${network.domain.tail}";
          target = "_blank";
        }
        {
          name = "VueTorrent";
          logo = "share/assets/icons/vuetorrent.png";
          subtitle = "Manage Torrents";
          tag = "download";
          keywords = "torrent download";
          url = "http://vuetorrent.${network.domain.tail}";
          target = "_blank";
        }
        {
          name = "Radarr";
          logo = "share/assets/icons/radarr.png";
          subtitle = "Manage Movies";
          tag = "movies";
          keywords = "movies media";
          url = "http://radarr.${network.domain.tail}";
          target = "_blank";
        }
        {
          name = "Sonarr";
          logo = "share/assets/icons/sonarr.png";
          subtitle = "Manage TV Shows";
          tag = "tv";
          keywords = "tv shows media";
          url = "http://sonarr.${network.domain.tail}";
          target = "_blank";
        }
      ];
    }
    {
      name = "Devices";
      icon = "fas fa-house-signal";
      items = [
        {
          name = "TP-Link Archer";
          logo = "share/assets/icons/tplink.png";
          subtitle = "Wireless Access Point";
          tag = "wireless";
          keywords = "wireless router access point";
          url = "http://tplink.${network.domain.tail}";
          target = "_blank";
        }
        {
          name = "AdGuard";
          logo = "share/assets/icons/adguard.png";
          subtitle = "DNS Ad Blocking";
          tag = "dns";
          keywords = "dns adblock";
          url = "http://adguard.${network.domain.tail}";
          target = "_blank";
        }
        {
          name = "Home Assistant";
          logo = "share/assets/icons/home-assistant.png";
          subtitle = "Smart Home Automation";
          tag = "smart-home";
          keywords = "smart home assistant automation";
          url = "http://home-assistant.${network.domain.tail}";
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
          logo = "share/assets/icons/netdata.png";
          subtitle = "Monitor Hardware";
          tag = "monitor";
          keywords = "monitor";
          url = "http://netdata.${network.domain.tail}";
          target = "_blank";
        }
        {
          name = "Gatus";
          logo = "share/assets/icons/gatus.png";
          subtitle = "Monitor Services";
          tag = "monitor";
          keywords = "monitor";
          url = "http://gatus.${network.domain.tail}";
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
          logo = "share/assets/icons/olivetin.png";
          subtitle = "Execute Commands";
          tag = "exec";
          keywords = "exec";
          url = "http://olivetin.${network.domain.tail}";
          target = "_blank";
        }
      ];
    }
  ];
}