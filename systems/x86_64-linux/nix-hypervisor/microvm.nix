{
  inputs,
  self,
  properties,
  ...
}: {
  systemd.tmpfiles.rules = [
    # Share journald logs on nix-hypervisor
    "L+ /var/log/journal/${properties.network.micro-media.machine-id}      -   -   -   -   /var/lib/microvms/micro-media/storage/journal/${properties.network.micro-media.machine-id}         "
    "L+ /var/log/journal/${properties.network.micro-server.machine-id}     -   -   -   -   /var/lib/microvms/micro-server/storage/journal/${properties.network.micro-server.machine-id}       "
    "L+ /var/log/journal/${properties.network.micro-tailscale.machine-id}  -   -   -   -   /var/lib/microvms/micro-tailscale/storage/journal/${properties.network.micro-tailscale.machine-id} "
    "L+ /var/log/journal/${properties.network.micro-infra.machine-id}      -   -   -   -   /var/lib/microvms/micro-infra/storage/journal/${properties.network.micro-infra.machine-id}         "
    "L+ /var/log/journal/${properties.network.micro-download.machine-id}   -   -   -   -   /var/lib/microvms/micro-download/storage/journal/${properties.network.micro-download.machine-id}   "
    "L+ /var/log/journal/${properties.network.micro-automate.machine-id}   -   -   -   -   /var/lib/microvms/micro-automate/storage/journal/${properties.network.micro-automate.machine-id}   "
  ];
  microvm = {
    vms = {
      micro-media = {
        specialArgs = {
          inherit inputs self properties;
        };
        config.imports = [
          (self + /share/microvm)
          (self + /share/all)
          ./vms/micro-media
        ];
      };
      micro-server = {
        specialArgs = {
          inherit inputs self properties;
        };
        config.imports = [
          (self + /share/microvm)
          (self + /share/all)
          ./vms/micro-server
        ];
      };
      micro-infra = {
        specialArgs = {
          inherit inputs self properties;
        };
        config.imports = [
          (self + /modules/nixos/yamlConfigMaker)
          (self + /share/microvm)
          (self + /share/all)
          ./vms/micro-infra
        ];
      };
      micro-tailscale = {
        specialArgs = {
          inherit inputs self properties;
        };
        config.imports = [
          (self + /share/microvm)
          (self + /share/all)
          ./vms/micro-tailscale
        ];
      };
      micro-download = {
        specialArgs = {
          inherit inputs self properties;
        };
        config.imports = [
          (self + /share/microvm)
          (self + /share/all)
          ./vms/micro-download
        ];
      };
      micro-automate = {
        specialArgs = {
          inherit inputs self properties;
        };
        config.imports = [
          (self + /share/microvm)
          (self + /share/all)
          ./vms/micro-automate
        ];
      };
    };
  };
}
