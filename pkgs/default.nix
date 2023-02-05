{ pkgs ? (import ../nixpkgs.nix) { } }: {
  olivetin = pkgs.callPackage ./olivetin { };
  hacs-govee = pkgs.callPackage ./hacs-govee { };
  bios = pkgs.callPackage ./bios { };
}