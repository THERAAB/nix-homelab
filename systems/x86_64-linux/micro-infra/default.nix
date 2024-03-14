{...}: {
  imports = [
    ./homer
    ./adguard.nix
    ./hardware.nix
    ./unifi.nix
    ./gotify.nix
  ];
  nix-homelab.services = {
    gatus.enable = true;
  };
}
