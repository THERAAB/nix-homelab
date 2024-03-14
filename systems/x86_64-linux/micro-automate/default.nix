{...}: {
  imports = [
    ./hardware.nix
    ./home-assistant
  ];
  nix-homelab = {
    microvm.enable = true;
    wrappers.home-assistant.enable = true;
  };
}
