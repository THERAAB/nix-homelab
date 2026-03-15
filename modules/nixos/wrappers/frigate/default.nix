{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.frigate;
in {
  options.nix-homelab.wrappers.frigate = with types; {
    enable = mkEnableOption (lib.mdDoc "Frigate");
  };
  config = mkIf cfg.enable {
    services.frigate = {
      enable = true;
      hostname = "localhost";

      settings = {
        mqtt.enabled = false;

        #detectors.ov = {
        #  type = "openvino";
        #  device = "AUTO";
        #  model.path = "/var/lib/frigate/openvino-model/ssdlite_mobilenet_v2.xml";
        #};

        #record = {
        #  enabled = true;
        #  retain = {
        #    days = 2;
        #    mode = "all";
        #  };
        #};

        cameras."test1" = {
          ffmpeg.inputs = [
            {
              path = "rtsp://127.0.0.1:8554/doorbell";
              input_args = "preset-rtsp-restream";
              roles = ["record"];
            }
          ];
        };
      };
    };

    systemd.services.frigate = {
      serviceConfig = {
        SupplementaryGroups = ["render" "video"];
        AmbientCapabilities = "CAP_PERFMON";
      };
    };
    services.go2rtc = {
      enable = true;
      settings = {
        streams = {
          "doorbell" = [
            "rtsp://@192.168.127.11"
          ];
        };
        rtsp = {
          listen = ":8554";
        };
        webrtc.listen = ":8555";
      };
    };
    systemd.services.go2rtc.serviceConfig.EnvironmentFile = config.sops.secrets.go2rtc_env.path;
  };
}
