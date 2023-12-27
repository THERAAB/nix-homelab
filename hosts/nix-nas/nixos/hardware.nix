{...}: {
  networking.hostName = "nix-nas"; # Define your hostname.
  networking.networkmanager.enable = true;
}
