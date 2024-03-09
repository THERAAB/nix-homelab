let
  network = import ../../../share/network.properties.nix;
in {
  # See https://fontawesome.com/v5/search for icons options
  title = "Nix Homelab";
  subtitle = "Services Dashboard";
  logo = "assets/icons/nixos.png";
  header = true;
  footer = false;
  theme = "default";
  colors = {
    dark = {
      highlight-primary = "transparent";
      highlight-secondary = "#414559";
      highlight-hover = "#414559";
      background = "#303446";
      card-background = "#414559";
      text = "#c6d0f5";
      text-header = "#c6d0f5";
      text-title = "#c6d0f5";
      text-subtitle = "#ca9ee6";
      card-shadow = "rgba(0, 0, 0, 0.1)";
    };
    light = {
      highlight-primary = "transparent";
      highlight-secondary = "#e6e9ef";
      highlight-hover = "#e6e9ef";
      background = "#eff1f5";
      card-background = "#e6e9ef";
      text = "#4c4f69";
      text-header = "#4c4f69";
      text-title = "#4c4f69";
      text-subtitle = "#ea76cb";
      card-shadow = "rgba(0, 0, 0, 0.1)";
    };
  };
  links = [
    {
      name = "GitHub";
      icon = "fab fa-github";
      url = "https://github.com/";
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
      name = "Micro-Media";
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
          url = "https://audiobooks.${network.domain}";
          target = "_blank";
        }
      ];
    }
    {
      name = "Micro-Download";
      icon = "fas fa-play";
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
          name = "Readarr";
          logo = "assets/icons/readarr.png";
          subtitle = "Manage Books";
          tag = "books";
          keywords = "books audiobooks media";
          url = "https://readarr.${network.domain}";
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
      name = "Micro-Server";
      icon = "fas fa-server";
      items = [
        {
          name = "Flatnotes";
          logo = "assets/icons/flatnotes.png";
          subtitle = "Edit/View Notes";
          tag = "notes";
          keywords = "notes";
          url = "https://notes.${network.domain}";
          target = "_blank";
        }
        {
          name = "Photoprism";
          logo = "assets/icons/photoprism.png";
          subtitle = "View & Manage Photos";
          tag = "photos";
          keywords = "photos media";
          url = "https://photos.${network.domain}";
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
        {
          name = "Linkding";
          logo = "assets/icons/linkding.png";
          subtitle = "Bookmark Manager";
          tag = "bookmark";
          keywords = "bookmark manager";
          url = "https://bookmarks.${network.domain}";
          target = "_blank";
        }
        {
          name = "File Browser";
          logo = "assets/icons/filebrowser.png";
          subtitle = "File Management";
          tag = "file";
          keywords = "file manager";
          url = "https://files.${network.domain}";
          target = "_blank";
        }
        {
          name = "Microbin";
          logo = "assets/icons/microbin.png";
          subtitle = "Pastebin server";
          tag = "pastebin";
          keywords = "pastebin";
          url = "https://microbin.${network.domain}";
          target = "_blank";
        }
      ];
    }
    {
      name = "Micro-Infra";
      icon = "fas fa-wrench";
      items = [
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
          name = "Unifi Network Application";
          logo = "assets/icons/unifi.png";
          subtitle = "Wireless Access Point";
          tag = "wireless";
          keywords = "wireless router access point";
          url = "https://unifi.${network.domain}";
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
        {
          name = "Gotify";
          logo = "assets/icons/gotify.png";
          subtitle = "Send Notifications";
          tag = "notify";
          keywords = "notify alert";
          url = "https://gotify.${network.domain}";
          target = "_blank";
        }
      ];
    }
    {
      name = "Nix-Hypervisor";
      icon = "fas fa-desktop";
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
          name = "SyncThing";
          logo = "assets/icons/syncthing.png";
          subtitle = "Shared Data & Folders";
          tag = "sync";
          keywords = "sync backup share data media";
          url = "https://sync.${network.domain}";
          target = "_blank";
        }
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
    {
      name = "Micro-Tailscale";
      icon = "fas fa-border-none";
      items = [
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
    {
      name = "Devices";
      icon = "fas fa-sd-card";
      items = [
        {
          name = "PfSense";
          logo = "assets/icons/pfsense.png";
          subtitle = "Firewall Router";
          tag = "wireless";
          keywords = "router firewall";
          url = "https://pfsense.pumpkin.rodeo/";
          target = "_blank";
        }
      ];
    }
  ];
}
