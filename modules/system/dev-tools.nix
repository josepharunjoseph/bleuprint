# Core Development Tools & Utilities
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Version control
    git              # https://git-scm.com/doc - Git version control
    git-lfs          # https://git-lfs.github.io/ - Git Large File Storage
    gh               # https://cli.github.com/ - GitHub CLI
    lazygit          # https://github.com/jesseduffield/lazygit - Terminal UI for git
    
    # Build systems & task runners
    cmake            # https://cmake.org/documentation/ - Cross-platform build system
    gnumake          # https://www.gnu.org/software/make/manual/ - GNU Make
    just             # https://github.com/casey/just - Modern make alternative
    ninja            # https://ninja-build.org/ - Small build system with focus on speed
    
    # Network & download tools
    curl             # https://curl.se/docs/ - Command line tool for transferring data
    wget             # https://www.gnu.org/software/wget/manual/ - Network downloader
    httpie           # https://httpie.io/ - Modern HTTP client
    
    # Archive & compression
    unzip            # Extract ZIP archives
    p7zip            # 7-Zip archive utility
    
    # Text processing & manipulation
    jq               # https://stedolan.github.io/jq/ - JSON processor
    yq               # https://github.com/mikefarah/yq - YAML/JSON/XML processor
    
    # Development utilities
    tree             # Display directory tree structure
    watch            # Execute command periodically
    entr             # Run commands when files change
    
    # Container & virtualization tools
    docker           # https://docs.docker.com/ - Container platform
    docker-compose   # https://docs.docker.com/compose/ - Multi-container applications
    
    # Database tools
    sqlite           # https://sqlite.org/ - Lightweight database
    
    # Documentation tools
    pandoc           # https://pandoc.org/ - Universal document converter
    
    # Performance & monitoring
    htop             # https://htop.dev/ - Interactive process viewer
    btop             # https://github.com/aristocratos/btop - Resource monitor
    
    # Security tools
    gnupg            # https://gnupg.org/ - GNU Privacy Guard
    
    # Shell & terminal enhancements
    tmux             # https://github.com/tmux/tmux - Terminal multiplexer
    screen           # GNU Screen terminal multiplexer
    
    # File synchronization
    rsync            # https://rsync.samba.org/ - File synchronization tool
  ];
  
  # Development environment variables
  environment.variables = {
    # Editor preferences
    EDITOR = "nvim";                    # Default editor
    VISUAL = "nvim";                    # Visual editor
    
    # Development settings
    DOCKER_BUILDKIT = "1";              # Enable Docker BuildKit
    COMPOSE_DOCKER_CLI_BUILD = "1";     # Use Docker CLI for builds
    
    # Git configuration
    GIT_EDITOR = "nvim";                # Git editor
  };
  
  # Development aliases
  environment.shellAliases = {
    # Git shortcuts (basic ones, language modules can add more)
    g = "git";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git log --oneline --graph";
    gd = "git diff";
    
    # GitHub CLI
    ghpr = "gh pr create";
    ghpv = "gh pr view";
    ghpc = "gh pr checkout";
    
    # Docker shortcuts
    d = "docker";
    dc = "docker compose";
    dps = "docker ps";
    di = "docker images";
    
    # Build tools
    mk = "make";
    j = "just";
    
    # Utilities
    http = "httpie";
    json = "jq";
    yaml = "yq";
    
    # Process monitoring
    top = "btop";
    processes = "htop";
    
    # File operations
    ll = "ls -la";
    tree = "tree -C";
    
    # Network
    myip = "curl -s https://ipinfo.io/ip";
    weather = "curl -s wttr.in";
  };
} 