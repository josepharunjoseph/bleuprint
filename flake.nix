{
  description = "Modular Mac setup with essential tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager }:
  let 
    system = "aarch64-darwin";
  in {
    darwinConfigurations."bleuprint" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        # Import modular configuration files
        ./modules/system/core.nix
        ./modules/system/cli-utils.nix
        ./modules/homebrew/apps.nix
        
        # Home Manager configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.YOUR-USERNAME = import ./modules/home/default.nix;
        }
      ];
    };
  };
}
