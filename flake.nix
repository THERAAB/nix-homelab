{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      snowfall.namespace = "nix-homelab";
      channels-config.allowUnfree = true;

      systems.modules.nixos = with inputs; [
        impermanence.nixosModules.impermanence
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        ./share/physical/nixos
        ./share/all
      ];
      systems.hosts.nix-hypervisor.modules = with inputs; [
        microvm.nixosModules.host
      ];

      homes.users."raab@nix-hypervisor".modules = with inputs; [
        impermanence.nixosModules.home-manager.impermanence
        ./share/physical/home
      ];
      homes.users."raab@nix-nas".modules = with inputs; [
        impermanence.nixosModules.home-manager.impermanence
        ./share/physical/home
      ];
    };
}
