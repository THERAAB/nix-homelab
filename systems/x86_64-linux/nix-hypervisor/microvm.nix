{
  inputs,
  self,
  network,
  media,
  users,
  ports,
  ...
}: {
  systemd.tmpfiles.rules = [
    # Share journald logs on nix-hypervisor
    "L+ /var/log/journal/${network.micro-media.machine-id}      -   -   -   -   /var/lib/microvms/micro-media/storage/journal/${network.micro-media.machine-id}         "
    "L+ /var/log/journal/${network.micro-server.machine-id}     -   -   -   -   /var/lib/microvms/micro-server/storage/journal/${network.micro-server.machine-id}       "
    "L+ /var/log/journal/${network.micro-tailscale.machine-id}  -   -   -   -   /var/lib/microvms/micro-tailscale/storage/journal/${network.micro-tailscale.machine-id} "
    "L+ /var/log/journal/${network.micro-infra.machine-id}      -   -   -   -   /var/lib/microvms/micro-infra/storage/journal/${network.micro-infra.machine-id}         "
    "L+ /var/log/journal/${network.micro-download.machine-id}   -   -   -   -   /var/lib/microvms/micro-download/storage/journal/${network.micro-download.machine-id}   "
    "L+ /var/log/journal/${network.micro-automate.machine-id}   -   -   -   -   /var/lib/microvms/micro-automate/storage/journal/${network.micro-automate.machine-id}   "
  ];
  microvm = {
    vms = {
      micro-media = {
        specialArgs = {
          inherit inputs self network media users ports;
        };
        config.imports = [
          (self + /share/microvm)
          (self + /share/all)
          ./vms/micro-media
        ];
      };
      micro-server = {
        specialArgs = {
          inherit inputs self network media users ports;
        };
        config.imports = [
          (self + /share/microvm)
          (self + /share/all)
          ./vms/micro-server
        ];
      };
      micro-infra = {
        specialArgs = {
          inherit inputs self network media users ports;
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
          inherit inputs self network media users ports;
        };
        config.imports = [
          (self + /share/microvm)
          (self + /share/all)
          ./vms/micro-tailscale
        ];
      };
      micro-download = {
        specialArgs = {
          inherit inputs self network media users ports;
        };
        config.imports = [
          (self + /share/microvm)
          (self + /share/all)
          ./vms/micro-download
        ];
      };
      micro-automate = {
        specialArgs = {
          inherit inputs self network media users ports;
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
