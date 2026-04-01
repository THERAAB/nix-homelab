{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixinate.url = "github:matthewcroughan/nixinate";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    let
      self = inputs.self;
      properties = import (self + /assets/properties);
    in
    inputs.snowfall-lib.mkFlake {
      inherit inputs self;
      src = ./.;
      snowfall.namespace = "nix-homelab";
      channels-config.allowUnfree = true;
      apps = inputs.nixinate.nixinate.x86_64-linux self;

      overlays = with inputs; [
        niri-flake.overlays.niri
      ];
      homes.users = {
        "raab@nix-zenbook".modules = with inputs; [
          niri-flake.homeModules.niri
          noctalia.homeModules.default
        ];
        "raab@nix-desktop".modules = with inputs; [
          niri-flake.homeModules.niri
          noctalia.homeModules.default
        ];
      };
      systems = {
        modules.nixos = with inputs; [
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
        ];
        hosts = {
          nix-hypervisor.specialArgs = {
            inherit self properties;
          };
          nix-nas.specialArgs = {
            inherit self properties;
          };
          nix-zenbook.specialArgs = {
            inherit self properties;
          };
          nix-desktop.specialArgs = {
            inherit self properties;
          };
          graphical-installer.specialArgs = {
            inherit self properties;
          };
        };
      };
    };
}
