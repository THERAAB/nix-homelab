{...}: {
  imports = [
    ./adguard-tailscale.nix
    ./homer
    ./gatus
    ./caddy.nix
    ./gotify.nix
    ./linkding.nix
    ./flatnotes.nix
    ./microbin.nix
    ./filebrowser.nix
    ./photoprism.nix
    ./microvm.nix
  ];
}
