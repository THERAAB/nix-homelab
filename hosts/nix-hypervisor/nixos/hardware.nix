{...}: {
  networking = {
    hostName = "nix-hypervisor";
    networkmanager.enable = true;
  };
  services.irqbalance.enable = true;
}
