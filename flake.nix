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
        # Core system configuration
        ./modules/system/core.nix
        ./modules/system/cli-utils.nix
        ./modules/system/dev-tools.nix
        
        # Language-specific development stacks
        ./modules/languages/python.nix
        ./modules/languages/rust.nix
        ./modules/languages/javascript.nix
        ./modules/languages/go.nix
        
        # Optional: ML/Data Science stack (uncomment to enable)
        # ./modules/system/ml-stack.nix
        
        # Homebrew applications
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
