{...}: 
let
  network = import ../../../share/network.properties.nix;
  port = 8384;
in
{
  services.syncthing = {
    enable = true;
    relay.enable = false;
    openDefaultPorts = true;
    overrideDevices = false;
    overrideFolders = false;
    guiAddress = "0.0.0.0:${toString port}";
    settings = {
      options.urAccepted = -1;
      devices = {
        nix-server = {
          id = "W33BOU2-KH5UGR6-MLWF3FP-EO4D4MT-QJZHZ44-XGSW54C-JXWMZFB-W5DKMQU";
          addresses = ["tcp://${network.nix-server.local.ip}:22000" "tcp://${network.nix-server.tailscale.ip}:22000"];
          introducer = true;
        };
      };
    };
  };
}
