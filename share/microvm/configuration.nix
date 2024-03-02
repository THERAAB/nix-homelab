{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nix = {
    # Flake setup
    package = pkgs.nixVersions.stable;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };
  system.stateVersion = "23.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
