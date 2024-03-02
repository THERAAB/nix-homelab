{...}: {
  # Force kernel to use iommu (GPU passthrough)
  boot.kernelParams = ["intel_iommu=on" "iommu=pt"];
  networking.hostName = "nix-hypervisor";
  services.irqbalance.enable = true;
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };
}
