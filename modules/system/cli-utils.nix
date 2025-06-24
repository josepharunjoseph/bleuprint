{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Essential CLI tools (modern defaults)
    ripgrep      # https://github.com/BurntSushi/ripgrep - Fast grep alternative
    fzf          # https://github.com/junegunn/fzf - Fuzzy finder (most popular)
    bat          # https://github.com/sharkdp/bat - Better cat with syntax highlighting
    eza          # https://github.com/eza-community/eza - Modern ls replacement (default choice)
    fd           # https://github.com/sharkdp/fd - Fast find alternative
    tmux         # https://github.com/tmux/tmux/wiki - Terminal multiplexer
    neovim       # https://neovim.io/doc/ - Modern vim
    jq           # https://jqlang.github.io/jq/manual/ - JSON processor
    btop         # https://github.com/aristocratos/btop - Resource monitor (default choice)
    erdtree      # https://github.com/solidiquis/erdtree - Modern tree in Rust
    
    # Productivity CLI tools
    tealdeer     # https://github.com/dbrgn/tealdeer - Fast tldr client (Rust-based)
    zoxide       # https://github.com/ajeetdsouza/zoxide - Smarter cd
    direnv       # https://direnv.net/ - Directory-specific environments
    atuin        # https://github.com/atuinsh/atuin - Better shell history (default choice)
    starship     # https://starship.rs/ - Cross-shell prompt
    
    # File management
    ncdu         # https://dev.yorhel.nl/ncdu - Disk usage analyzer
    duf          # https://github.com/muesli/duf - Modern df
    dust         # https://github.com/bootandy/dust - Modern du
    procs        # https://github.com/dalance/procs - Modern ps
    bottom       # https://github.com/ClementTsang/bottom - System monitor
    btop         # https://github.com/aristocratos/btop - Resource monitor
    
    # Development utilities
    gh           # https://cli.github.com/manual/ - GitHub CLI
    gping        # https://github.com/orf/gping - Ping with graph
    xh           # https://github.com/ducaale/xh - Fast HTTP client (Rust-based, default choice)
    
    # Text processing
    sd           # https://github.com/chmln/sd - Intuitive find & replace
    choose       # https://github.com/theryangeary/choose - Human-friendly cut
    gron         # https://github.com/tomnomnom/gron - Make JSON greppable
    yq           # https://github.com/mikefarah/yq - YAML processor
    
    # Git enhancements
    delta        # https://github.com/dandavison/delta - Better git diffs
    gitui        # https://github.com/extrawurst/gitui - Git TUI
    lazygit      # https://github.com/jesseduffield/lazygit - Simple Git TUI
    
    # Network tools
    dog          # https://github.com/ogham/dog - Modern dig
    mtr          # https://github.com/traviscross/mtr - Network diagnostic
    nmap         # https://nmap.org/book/
    
    # Archive tools
    p7zip        # https://7-zip.org/
    unzip        # https://linux.die.net/man/1/unzip
    
    # Misc utilities
    tealdeer     # https://github.com/dbrgn/tealdeer - Fast tldr client
    tokei        # https://github.com/XAMPPRocky/tokei - Code statistics
    hyperfine    # https://github.com/sharkdp/hyperfine - Command benchmarking
    watchexec    # https://github.com/watchexec/watchexec - Run commands on file change
    
    # Additional Rust-based modern tools
    lsd          # https://github.com/lsd-rs/lsd - Next-gen ls (alternative to eza)
    broot        # https://github.com/Canop/broot - Better tree navigation
    mcfly        # https://github.com/cantino/mcfly - Smart shell history (alternative to atuin)
    skim         # https://github.com/lotabout/skim - Fuzzy finder in Rust (alternative to fzf)
    bandwhich    # https://github.com/imsnif/bandwhich - Network utilization by process
    grex         # https://github.com/pemistahl/grex - Generate regex from examples
    hexyl        # https://github.com/sharkdp/hexyl - Hex viewer
    pastel       # https://github.com/sharkdp/pastel - Color manipulation
    vivid        # https://github.com/sharkdp/vivid - LS_COLORS generator
    
    # System tools
    lsof         # https://github.com/lsof-org/lsof - List open files
    # Note: dtruss and fs_usage are built into macOS
    
    # Security tools  
    age          # https://github.com/FiloSottile/age - Modern encryption
    sops         # https://github.com/mozilla/sops - Secrets management
    gnupg        # GNU Privacy Guard
    yubikey-manager  # https://github.com/Yubico/yubikey-manager - YubiKey management
    
    # Container/VM tools
    act          # https://github.com/nektos/act - Run GitHub Actions locally
    podman       # https://podman.io/ - Container management (rootless)
    dive         # https://github.com/wagoodman/dive - Docker image explorer
    
    # Performance analysis
    # Note: perf is Linux-specific, use macOS Instruments instead
    flamegraph   # https://github.com/flamegraph-rs/flamegraph - Flame graph profiler
    
    # Additional dev tools
    mdbook       # https://github.com/rust-lang/mdBook - Create books from Markdown
    zellij       # https://github.com/zellij-org/zellij - Terminal workspace (tmux alternative)
    helix        # https://github.com/helix-editor/helix - Modern modal editor
    silicon      # https://github.com/Aloxaf/silicon - Code to image generator
    license-generator  # https://github.com/azu/license-generator - Generate LICENSE files
  ];
} 