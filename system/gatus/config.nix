{
  settings = {
    endpoints = [
      {
        name = "Adguard";
        url = "http://adguard.server.box/";
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<title>Login</title>*)''
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "Govee Water Alarm";
        url = "icmp://192.168.1.103";
        conditions = [
          "[CONNECTED] == true"
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "Home Assistant";
        url = "http://home-assistant.server.box/";
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<title>Home Assistant</title>*)''
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "Homer.box";
        url = "http://server.box/";
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<div id="app-mount"></div>*)''
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "Homer.tail";
        url = "http://server.tail/";
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<div id="app-mount"></div>*)''
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "Jellyseerr";
        url = "http://jellyseerr.server.box/health";
        conditions = [
          "[STATUS] == 200"
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "NetData";
        url = "http://netdata.server.box/";
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<title>netdata dashboard</title>*)''
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "PFSense";
        url = "https://192.168.1.1/";
        client.insecure = true;
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<title>pfSense - Login</title>*)''
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "Prowlarr";
        url = "http://prowlarr.server.box/health";
        conditions = [
          "[STATUS] == 200"
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "Radarr";
        url = "http://radarr.server.box/health";
        conditions = [
          "[STATUS] == 200"
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "Sonarr";
        url = "http://sonarr.server.box/health";
        conditions = [
          "[STATUS] == 200"
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "Ring Doorbell";
        url = "icmp://192.168.1.108";
        conditions = [
          "[CONNECTED] == true"
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "TP-Link Archer";
        url = "http://tplink.server.box/";
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<?xml version="1.0" encoding="utf-8"?>*)''
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
      {
        name = "VueTorrent";
        url = "http://vuetorrent.server.box/";
        conditions = [
          "[STATUS] == 200"
          ''[BODY] == pat(*<title>qBittorrent</title>*)''
        ];
        alerts = [
          {
            type = "custom";
          }
        ];
      }
    ];
  };
}