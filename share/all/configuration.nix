{
  lib,
  pkgs,
  outputs,
  ...
}: {
  nix = {
    # Flake setup
    package = pkgs.nixVersions.stable;
    settings.experimental-features = "nix-command flakes";
  };
  nixpkgs = {
    overlays = lib.mkDefault [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions
    ];
    config = lib.mkDefault {
      allowUnfree = true;
    };
  };
  system.stateVersion = "23.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
