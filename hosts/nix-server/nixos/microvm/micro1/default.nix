{...}: {
  imports = [
    #./home-assistant
    ./homer
    ./media
    ./gatus
    ./olivetin
    ./adguard
    #./caddy.nix
    ./users.nix
    #./photoprism.nix
    #./unifi.nix
    ./podman.nix
    #./harmonia.nix
    #./gotify.nix
    #./linkding.nix
    #./flatnotes.nix
    #./microbin.nix
    #./filebrowser.nix
    ./system.nix
    ./configuration.nix
  ];
}
