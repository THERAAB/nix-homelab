{
  pkgs,
  properties,
  config,
  ...
}: {
  imports = [
    ./hardware.nix
    ./adguard-tailscale.nix
  ];
  environment = {
    etc."machine-id" = {
      mode = "0644";
      text = properties.network.${config.networking.hostName}.machine-id + "\n";
    };
    variables.TERM = "xterm-256color";
    systemPackages = with pkgs; [
      fuse-overlayfs
    ];
  };
  users.allowNoPasswordLogin = true;
  security.sudo.execWheelOnly = true;
}
