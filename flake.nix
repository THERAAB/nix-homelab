{
  description = "Server flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager, impermanence, sops-nix }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        server = lib.nixosSystem { 
          inherit system;
          modules = [ 
            impermanence.nixosModules.impermanence
            ./configuration.nix
            sops-nix.nixosModules.sops
            
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.raab = { pkgs, ... }: {
                imports = [ impermanence.nixosModules.home-manager.impermanence
                            ./home.nix
                ];
              };
            }
          ];
        };
      };
    };
}
