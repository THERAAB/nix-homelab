{...}: {
  imports = [
    ./adguard.nix
    ./hardware.nix
  ];
  nix-homelab = {
    microvm.enable = true;
    wrappers = {
      gatus.enable = true;
      homer.enable = true;
      gotify.enable = true;
      unifi.enable = true;
    };
  };
}
