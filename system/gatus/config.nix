{
  settings = {
    alerting = {
      custom = {
        url = "https://api.pushbullet.com/v2/pushes";
        method = "POST";
        headers = {
          Access-Token = "<PLACEHOLDER>";
          Content-Type = "application/json";
        };
        body = ''|{"type": "note","title": "Gatus [ALERT_TRIGGERED_OR_RESOLVED]: [ENDPOINT_NAME]","body": "[ALERT_DESCRIPTION] - [ENDPOINT_URL]"}'';
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
        name = "Adguard";
        url = "http://adguard.server.box/";
        conditions = [
          "[STATUS] == 200"
          "[BODY] == pat(*<title>Login</title>*)"
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