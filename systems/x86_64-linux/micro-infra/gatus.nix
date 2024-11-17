let
  network = import ../../../assets/properties/network.nix;
  dns-port = 53;
in {
  alerting = {
    gotify = {
      server-url = "https://gotify.${network.domain}";
      token = "<PLACEHOLDER>";
      body = ''{"type":"note","title":"Gatus [ALERT_TRIGGERED_OR_RESOLVED]: [ENDPOINT_NAME]","body":"[ALERT_DESCRIPTION] - [ENDPOINT_URL]"}'';
      default-alert = {
        description = "Status Change";
        send-on-resolved = true;
        failure-threshold = 5;
        success-thershold = 3;
      };
    };
  };
  endpoints = [
    {
      name = "Olivetin";
      url = "https://olivetin.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>OliveTin</title>*)''
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Harmonia Cache";
      url = "https://cache.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>*harmonia*</title>*)''
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Netdata";
      url = "https://netdata.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "SyncThing";
      url = "https://sync.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Home Assistant";
      url = "https://home-assistant.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>Home Assistant</title>*)''
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Unifi Network Application";
      url = "https://unifi.${network.domain}";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
      client.insecure = true;
    }
    {
      name = "Photoprism";
      url = "https://photos.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>PhotoPrism</title>*)''
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "microbin";
      url = "https://microbin.${network.domain}";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Linkding";
      url = "https://bookmarks.${network.domain}/health";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Gotify";
      url = "https://gotify.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Flatnotes";
      url = "https://notes.${network.domain}";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "filebrowser";
      url = "https://files.${network.domain}";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Vuetorrent";
      url = "https://vuetorrent.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Sonarr";
      url = "https://tv.${network.domain}/health";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Tdarr";
      url = "https://transcode.${network.domain}/health";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Readarr";
      url = "https://readarr.${network.domain}/health";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Radarr";
      url = "https://movies.${network.domain}/health";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Prowlarr";
      url = "https://prowlarr.${network.domain}/health";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Jellyseerr";
      url = "https://jellyseerr.${network.domain}/health";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Jellyfin";
      url = "https://jellyfin.${network.domain}/health";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Audiobookshelf";
      url = "https://audiobooks.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Homer";
      url = "https://${network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<div id="app-mount"></div>*)''
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Adguard";
      url = "https://adguard.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>Login</title>*)''
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Adguard-tailscale";
      url = "https://adguard-tailscale.${network.domain}/";
      conditions = [
        "[STATUS] == 200"
        ''[BODY] == pat(*<title>Login</title>*)''
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Govee Water Alarm";
      url = "tcp://${network.govee-water-alarm.local.ip}:${toString dns-port}";
      conditions = [
        "[RESPONSE_TIME] < 500"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Ring Doorbell";
      url = "tcp://${network.ring-doorbell.local.ip}:${toString dns-port}";
      conditions = [
        "[RESPONSE_TIME] < 2500"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    #{
    #  name = "B-Hyve Water Pump Hub";
    #  url = "tcp://${network.b-hyve.local.ip}:${toString dns-port}";
    #  conditions = [
    #    "[RESPONSE_TIME] < 500"
    #  ];
    #  alerts = [
    #    {
    #      type = "gotify";
    #    }
    #  ];
    #}
    {
      name = "Ecobee Thermostat";
      url = "tcp://${network.ecobee.local.ip}:${toString dns-port}";
      conditions = [
        "[RESPONSE_TIME] < 500"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Unifi U6+";
      url = "tcp://${network.unifi-u6-plus.local.ip}:${toString dns-port}";
      conditions = [
        "[RESPONSE_TIME] < 500"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Unifi Lite 8 Switch";
      url = "tcp://${network.unifi-usw-lite-8.local.ip}:${toString dns-port}";
      conditions = [
        "[RESPONSE_TIME] < 500"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
    {
      name = "Nix-Nas";
      url = "udp://${network.nix-nas.local.ip}:${toString dns-port}";
      conditions = [
        "[RESPONSE_TIME] < 500"
      ];
      alerts = [
        {
          type = "gotify";
        }
      ];
    }
  ];
}
