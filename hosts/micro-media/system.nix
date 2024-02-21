{pkgs, ...}: {
  microvm = {
    kernelParams = ["i915.force_probe=4692"];
    mem = 8192;
    vcpu = 1;
    # hypervisor = lib.mkDefault "cloud-hypervisor";
    interfaces = [
      {
        type = "macvtap";
        macvtap = {
          mode = "bridge";
          link = "enp3s0";
        };
        id = "micro-media";
        mac = "02:00:00:00:00:01";
      }
    ];
    devices = [
      {
        bus = "pci";
        path = "0000:00:02.0";
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        source = "/run/secrets";
        mountPoint = "/run/secrets";
        tag = "secrets";
      }
      {
        proto = "virtiofs";
        source = "/var/lib/microvms/micro-media/storage/etc/ssh";
        mountPoint = "/etc/ssh";
        tag = "ssh";
      }
      {
        proto = "virtiofs";
        source = "/var/lib/microvms/micro-media/storage/var/lib";
        mountPoint = "/var/lib";
        tag = "var-lib";
      }
    ];
  };
  fileSystems = {
    "/etc/ssh".neededForBoot = true;
    "/var/lib".neededForBoot = true;
  };
  networking = {
    hostName = "micro-media";
    firewall = {
      trustedInterfaces = ["tailscale0"];
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [53];
    };
    networkmanager.enable = true;
  };
  environment.noXlibs = false;
  services.tailscale = {
    enable = true;
    extraUpFlags = ["--ssh"];
  };
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
