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
      name = "B-Hyve Water Pump Hub";
      url = "tcp://${network.b-hyve.local.ip}:53";
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
      name = "Ecobee Thermostat";
      url = "tcp://${network.ecobee.local.ip}:53";
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
      name = "Unifi U6+";
      url = "tcp://${network.unifi-u6-plus.local.ip}:53";
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
      name = "Unifi Lite 8 Switch";
      url = "tcp://${network.unifi-usw-lite-8.local.ip}:53";
      conditions = [
        "[RESPONSE_TIME] < 500"
      ];
      alerts = [
        {
          type = "custom";
        }
      ];
    }
  ];
}
