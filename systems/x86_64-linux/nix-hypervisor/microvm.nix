{
  properties,
  inputs,
  self,
  ...
}: {
  systemd.tmpfiles.rules = [
    # Share journald logs on nix-hypervisor
    "L+ /var/log/journal/${properties.network.micro-tailscale.machine-id}  -   -   -   -   /var/lib/microvms/micro-tailscale/storage/journal/${properties.network.micro-tailscale.machine-id} "
  ];
  microvm.vms.micro-tailscale = {
    specialArgs = {
      inherit inputs self properties;
    };
    config.imports = [
      (self + /share/nixos/microvm)
      ./vms/micro-tailscale
    ];
  };
}
