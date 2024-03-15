{...}: {
  imports = [
    ./adguard.nix
    ./hardware.nix
  ];
  nix-homelab = {
    microvm.enable = true;
    wrappers = {
      gatus = {
        enable = true;
        conf = import ./gatus.nix;
      };
      homer.enable = true;
      gotify.enable = true;
      unifi.enable = true;
    };
  };
}
