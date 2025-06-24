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
    # Get the base modules from main flake
    baseModules = bleuprint.darwinConfigurations."bleuprint".modules;
  in {
    darwinConfigurations."bleuprint" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = baseModules ++ [
        # CI-specific user overrides only
        {
          # Override primary user for CI
          system.primaryUser = "runner";
          
          # Define CI user (replaces YOUR-USERNAME)
          users.users.runner = {
            name = "runner";
            home = "/Users/runner";
          };
          
          # Remove template placeholder user
          users.users.YOUR-USERNAME = null;
          
          # Override home-manager user
          home-manager.users.runner = import ../modules/home/default.nix;
          home-manager.users.YOUR-USERNAME = null;
        }
      ];
    };
  };
} 