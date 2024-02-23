{...}: {
  networking = {
    networkmanager.enable = true;
  };
  services.irqbalance.enable = true;
}
