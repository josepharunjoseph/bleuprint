{
  description = "CI-specific configuration for Bleuprint - imports main flake with CI user overrides";

  inputs = {
    # Import the main flake and all its inputs
    bleuprint.url = "path:..";
    nixpkgs.follows = "bleuprint/nixpkgs";
    nix-darwin.follows = "bleuprint/nix-darwin";
    home-manager.follows = "bleuprint/home-manager";
  };

  outputs = { self, bleuprint, nixpkgs, nix-darwin, home-manager }:
  let 
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    darwinConfigurations."bleuprint" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        # Core system configuration
        ../modules/system/core.nix
        ../modules/system/cli-utils.nix
        ../modules/system/dev-tools.nix
        
        # Language-specific development stacks
        ../modules/languages/python.nix
        ../modules/languages/rust.nix
        ../modules/languages/javascript.nix
        ../modules/languages/go.nix
        
        # Homebrew applications
        ../modules/homebrew/apps.nix
        
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        
        # CI-specific user overrides only
        ({ lib, ... }: {
          # Force override primary user for CI
          system.primaryUser = lib.mkForce "runner";
          
          # Define CI user (replaces YOUR-USERNAME)
          users.users.runner = {
            name = "runner";
            home = "/Users/runner";
          };
          
          # Override home-manager user
          home-manager.users.runner = import ../modules/home/default.nix;
        })
      ];
    };
  };
} 