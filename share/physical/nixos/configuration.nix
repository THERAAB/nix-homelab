{
  inputs,
  outputs,
  lib,
  config,
  nixpkgs-unstable,
  ...
}: {
  nixpkgs = {
    overlays = lib.mkDefault [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions
      (final: prev: {
        unstable = import nixpkgs-unstable {
          system = prev.system;
        };
      })
    ];
    config = lib.mkDefault {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings.auto-optimise-store = true;
  };
}
