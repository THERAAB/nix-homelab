{...}: {
  # Force kernel to use iommu (GPU passthrough)
  boot.kernelParams = ["intel_iommu=on" "iommu=pt"];
  networking = {
    hostName = "nix-hypervisor";
    networkmanager.enable = true;
  };
  services.irqbalance.enable = true;
}
