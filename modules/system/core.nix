{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core development languages
    git          # https://git-scm.com/doc
    go_1_24      # https://go.dev/doc/ - Go 1.24 (1.24 coming Feb 2025)
    rustup       # https://rustup.rs/ - Rust toolchain manager (for 1.85+)
    python313    # https://docs.python.org/3.13/ - Python 3.13 LTS
    nodejs_22    # https://nodejs.org/docs/latest-v22.x/api/ - Node.js 22 LTS
    
    # Build tools
    cmake        # https://cmake.org/documentation/
    gnumake      # https://www.gnu.org/software/make/manual/
    just         # https://github.com/casey/just - Modern make alternative
    ninja        # https://ninja-build.org/ - Small build system
    
    # Environment management
    direnv       # https://direnv.net/ - Directory-specific environments
    nix-direnv   # https://github.com/nix-community/nix-direnv - Nix integration for direnv
    
    # Essential network tools
    curl         # https://curl.se/docs/
    wget         # https://www.gnu.org/software/wget/manual/
  ];

  # System settings
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      mru-spaces = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXDefaultSearchScope = "SCcf";  # Current folder
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;  # Full keyboard access
      ApplePressAndHoldEnabled = false;  # Key repeat
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };
  };

  # Enable Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Services
  services.nix-daemon.enable = true;
  
  # Post-rebuild tool discovery
  system.activationScripts.toolDiscovery.text = ''
    PREV_TOOLS=/etc/static-tool-list.txt
    CURRENT_TOOLS=/run/current-system/sw/bin
    
    if [[ -d "$CURRENT_TOOLS" ]]; then
      if [[ -f "$PREV_TOOLS" ]]; then
        # Show newly added tools
        NEW_TOOLS=$(comm -13 <(sort "$PREV_TOOLS") <(ls "$CURRENT_TOOLS" | sort) | head -10)
        if [[ -n "$NEW_TOOLS" ]]; then
          echo "✨ New tools available:"
          echo "$NEW_TOOLS" | sed 's/^/  - /'
        fi
      fi
      
      # Update tool list
      ls "$CURRENT_TOOLS" > "$PREV_TOOLS" 2>/dev/null || true
    fi
  '';
  nix.settings = {
    experimental-features = "nix-command flakes";
    # Harden against power loss (Nix 2.25+)
    fsync-metadata = true;
    # Additional performance and security settings
    auto-optimise-store = true;
    sandbox = true;
    max-jobs = "auto";
    cores = 0; # Use all available cores
    
    # Binary cache optimization for faster rebuilds
    substituters = [
      "https://cache.nixos.org"
      "https://numtide.cachix.org"  # Community cache with many Rust CLI tools
      "https://nix-community.cachix.org"  # Nix community projects
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy2Uw6kQFyy80GFUz0WCuO6qPwKOY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    
    # Build performance optimization
    keep-outputs = true;
    keep-derivations = true;
  };
} 