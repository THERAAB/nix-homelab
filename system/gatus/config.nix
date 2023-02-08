{
  alerting = {
    custom = {
      url = "https://api.pushbullet.com/v2/pushes";
      method = "POST";
      headers = {
        Access-Token = "<PLACEHOLDER>";
        Content-Type = "application/json";
      };
      body = ''{"type":"note","title":"Gatus [ALERT_TRIGGERED_OR_RESOLVED]: [ENDPOINT_NAME]","body":"[ALERT_DESCRIPTION] - [ENDPOINT_URL]"}'';
      default-alert = {
        description = "Request Failed!";
        send-on-resolved = true;
        failure-threshold = 5;
        success-thershold = 3;
      };
    };
  };
  endpoints = [
    {
      name = "Govee Water Alarm";
      url = "tcp://192.168.1.103:53";
      conditions = [
        "[STATUS] == 0"
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
      name = "Ring Doorbell";
      url = "tcp://192.168.1.108:8557";
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
  ];
}