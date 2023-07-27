let
  network = import ../../../../share/network.properties.nix;
in {
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
      url = "tcp://${network.govee-water-alarm.local.ip}:53";
      conditions = [
        "[RESPONSE_TIME] < 500"
      ];
      alerts = [
        {
          type = "custom";
        }
      ];
    }
    {
      name = "Ring Doorbell";
      url = "tcp://${network.ring-doorbell.local.ip}:53";
      conditions = [
        "[RESPONSE_TIME] < 2500"
      ];
      alerts = [
        {
          type = "custom";
        }
      ];
    }
    {
      name = "Unifi AP 6+";
      url = "https://192.168.3.2:8443/";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "custom";
        }
      ];
      client.insecure = true;
    }
  ];
}
