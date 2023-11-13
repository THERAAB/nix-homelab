{...}: {
  imports = [
    ./home-assistant
    ./homer
    ./media
    ./gatus
    ./olivetin
    ./adguard
    ./hardware-configuration.nix
    ./caddy.nix
    ./netdata.nix
    ./users.nix
    ./hardware.nix
    ./sops.nix
    ./photoprism.nix
    ./unifi-new.nix
    ./podman.nix
    ./cloudflared.nix
  ];
}
