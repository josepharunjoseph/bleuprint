{ pkgs, ... }:

{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";  # Remove unlisted apps
    
    brews = [
      # Mac-specific tools
      "mas"         # Mac App Store CLI - https://github.com/mas-cli/mas
      
      # Services
      "tailscale"   # Zero-config VPN - https://tailscale.com/kb/
      "mkcert"      # Local HTTPS certs - https://github.com/FiloSottile/mkcert
      "postgresql@16"  # Database - https://www.postgresql.org/docs/16/
      "redis"       # In-memory data store - https://redis.io/docs/
      
      # Additional CLI tools better installed via Homebrew
      "watch"       # Run commands periodically
      "fswatch"     # File change monitor - https://github.com/emcrisostomo/fswatch
    ];
    
    casks = [
      # Essential GUI apps
      "raycast"           # Launcher & productivity - https://raycast.com/
      "visual-studio-code" # Code editor - https://code.visualstudio.com/docs
      "orbstack"          # Docker alternative - https://orbstack.dev/
      "kitty"             # GPU terminal - https://sw.kovidgoyal.net/kitty/
      
      # Productivity
      "obsidian"          # Note-taking - https://obsidian.md/
      "slack"             # Team communication - https://slack.com/
      "notion"            # All-in-one workspace - https://notion.so/
      
      # Development tools
      "github"            # GitHub Desktop - https://desktop.github.com/
      "insomnia"          # API client - https://insomnia.rest/
      "tableplus"         # Database GUI - https://tableplus.com/
      
      # System utilities
      "stats"             # Menu bar system monitor - https://github.com/exelban/stats
      "rectangle"         # Window management - https://rectangleapp.com/
      "iina"              # Modern media player - https://iina.io/
      "the-unarchiver"    # Archive utility - https://theunarchiver.com/
      
      # Optional but useful
      "cleanmymac"        # System cleaner - https://cleanmymac.com/
      "iterm2"            # Alternative terminal - https://iterm2.com/
      "wezterm"           # GPU-accelerated terminal - https://wezfurlong.org/wezterm/
      
      # Security
      "1password"         # Password manager - https://1password.com/
      "1password-cli"     # 1Password CLI - https://developer.1password.com/docs/cli/
    ];
    
    masApps = {
      # Xcode = 497799835;           # Apple IDE
      # "Things 3" = 904280696;      # Task manager
      # "Amphetamine" = 937984704;   # Keep Mac awake
    };
  };
} 