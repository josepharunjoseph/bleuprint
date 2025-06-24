# CLI Tools Cheatsheet

> 🚀 Quick reference for all 120+ CLI tools included in this configuration

*This file is auto-generated from the Nix configuration. Do not edit manually.*

## Navigation & Discovery

```bash
# Find what tools are available
ls /run/current-system/sw/bin | grep -v '^[A-Z]' | sort

# Get help for any tool
<tool-name> --help
tldr <tool-name>        # Quick examples
man <tool-name>         # Full manual

# Tool alternatives (when modernTools.enable = true)
ls2, tree2, fzf2, vim2, tmux2, etc.
```

## Tool Categories

### Core Development Tools

- **`    git          `** -  https://git-scm.com/doc
- **`    go_1_24      `** -  https://go.dev/doc/ - Go 1.24 (1.24 coming Feb 2025)
- **`    rustup       `** -  https://rustup.rs/ - Rust toolchain manager (for 1.85+)
- **`    python313    `** -  https://docs.python.org/3.13/ - Python 3.13 LTS
- **`    nodejs_22    `** -  https://nodejs.org/docs/latest-v22.x/api/ - Node.js 22 LTS
- **`    cmake        `** -  https://cmake.org/documentation/
- **`    gnumake      `** -  https://www.gnu.org/software/make/manual/
- **`    just         `** -  https://github.com/casey/just - Modern make alternative
- **`    ninja        `** -  https://ninja-build.org/ - Small build system
- **`    direnv       `** -  https://direnv.net/ - Directory-specific environments
- **`    nix-direnv   `** -  https://github.com/nix-community/nix-direnv - Nix integration for direnv
- **`    curl         `** -  https://curl.se/docs/
- **`    wget         `** -  https://www.gnu.org/software/wget/manual/

### CLI Utilities

- **`    ripgrep      `** -  https://github.com/BurntSushi/ripgrep - Fast grep alternative
- **`    fzf          `** -  https://github.com/junegunn/fzf - Fuzzy finder (most popular)
- **`    bat          `** -  https://github.com/sharkdp/bat - Better cat with syntax highlighting
- **`    eza          `** -  https://github.com/eza-community/eza - Modern ls replacement (default choice)
- **`    fd           `** -  https://github.com/sharkdp/fd - Fast find alternative
- **`    tmux         `** -  https://github.com/tmux/tmux/wiki - Terminal multiplexer
- **`    neovim       `** -  https://neovim.io/doc/ - Modern vim
- **`    jq           `** -  https://jqlang.github.io/jq/manual/ - JSON processor
- **`    btop         `** -  https://github.com/aristocratos/btop - Resource monitor (default choice)
- **`    erd          `** -  https://github.com/solidiquis/erdtree - Modern tree in Rust
- **`    tealdeer     `** -  https://github.com/dbrgn/tealdeer - Fast tldr client (Rust-based)
- **`    zoxide       `** -  https://github.com/ajeetdsouza/zoxide - Smarter cd
- **`    direnv       `** -  https://direnv.net/ - Directory-specific environments
- **`    atuin        `** -  https://github.com/atuinsh/atuin - Better shell history (default choice)
- **`    starship     `** -  https://starship.rs/ - Cross-shell prompt
- **`    ncdu         `** -  https://dev.yorhel.nl/ncdu - Disk usage analyzer
- **`    duf          `** -  https://github.com/muesli/duf - Modern df
- **`    dust         `** -  https://github.com/bootandy/dust - Modern du
- **`    procs        `** -  https://github.com/dalance/procs - Modern ps
- **`    bottom       `** -  https://github.com/ClementTsang/bottom - System monitor
- **`    btop         `** -  https://github.com/aristocratos/btop - Resource monitor
- **`    gh           `** -  https://cli.github.com/manual/ - GitHub CLI
- **`    gping        `** -  https://github.com/orf/gping - Ping with graph
- **`    xh           `** -  https://github.com/ducaale/xh - Fast HTTP client (Rust-based, default choice)
- **`    sd           `** -  https://github.com/chmln/sd - Intuitive find & replace
- **`    choose       `** -  https://github.com/theryangeary/choose - Human-friendly cut
- **`    gron         `** -  https://github.com/tomnomnom/gron - Make JSON greppable
- **`    yq           `** -  https://github.com/mikefarah/yq - YAML processor
- **`    delta        `** -  https://github.com/dandavison/delta - Better git diffs
- **`    gitui        `** -  https://github.com/extrawurst/gitui - Git TUI
- **`    lazygit      `** -  https://github.com/jesseduffield/lazygit - Simple Git TUI
- **`    dog          `** -  https://github.com/ogham/dog - Modern dig
- **`    mtr          `** -  https://github.com/traviscross/mtr - Network diagnostic
- **`    nmap         `** -  https://nmap.org/book/
- **`    p7zip        `** -  https://7-zip.org/
- **`    unzip        `** -  https://linux.die.net/man/1/unzip
- **`    tealdeer     `** -  https://github.com/dbrgn/tealdeer - Fast tldr client
- **`    tokei        `** -  https://github.com/XAMPPRocky/tokei - Code statistics
- **`    hyperfine    `** -  https://github.com/sharkdp/hyperfine - Command benchmarking
- **`    watchexec    `** -  https://github.com/watchexec/watchexec - Run commands on file change
- **`    lsd          `** -  https://github.com/lsd-rs/lsd - Next-gen ls (alternative to eza)
- **`    broot        `** -  https://github.com/Canop/broot - Better tree navigation
- **`    mcfly        `** -  https://github.com/cantino/mcfly - Smart shell history (alternative to atuin)
- **`    sk           `** -  https://github.com/lotabout/skim - Fuzzy finder in Rust (alternative to fzf)
- **`    bandwhich    `** -  https://github.com/imsnif/bandwhich - Network utilization by process
- **`    grex         `** -  https://github.com/pemistahl/grex - Generate regex from examples
- **`    hexyl        `** -  https://github.com/sharkdp/hexyl - Hex viewer
- **`    pastel       `** -  https://github.com/sharkdp/pastel - Color manipulation
- **`    vivid        `** -  https://github.com/sharkdp/vivid - LS_COLORS generator
- **`    lsof         `** -  https://github.com/lsof-org/lsof - List open files
- **`    dtruss       `** -  System call tracer (macOS)
- **`    fs_usage     `** -  File system usage (macOS)
- **`    age          `** -  https://github.com/FiloSottile/age - Modern encryption
- **`    sops         `** -  https://github.com/mozilla/sops - Secrets management
- **`    gpg          `** -  GNU Privacy Guard
- **`    yubikey-manager  `** -  https://github.com/Yubico/yubikey-manager - YubiKey management
- **`    act          `** -  https://github.com/nektos/act - Run GitHub Actions locally
- **`    podman       `** -  https://podman.io/ - Container management (rootless)
- **`    dive         `** -  https://github.com/wagoodman/dive - Docker image explorer
- **`    perf         `** -  Performance analysis tools
- **`    flamegraph   `** -  https://github.com/flamegraph-rs/flamegraph - Flame graph profiler
- **`    mdbook       `** -  https://github.com/rust-lang/mdBook - Create books from Markdown
- **`    zellij       `** -  https://github.com/zellij-org/zellij - Terminal workspace (tmux alternative)
- **`    helix        `** -  https://github.com/helix-editor/helix - Modern modal editor
- **`    silicon      `** -  https://github.com/Aloxaf/silicon - Code to image generator
- **`    license-generator  `** -  https://github.com/azu/license-generator - Generate LICENSE files

### GUI Applications (via Homebrew)

- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **
- **      **

## Common Usage Patterns

### File Operations
```bash
# Modern file listing
eza --icons --long --git         # Detailed view with git status
eza --tree --level=2             # Tree view, 2 levels deep

# File searching  
fd pattern                       # Find files by name
rg "search term" --type rust     # Search in files by type
```

### System Monitoring
```bash
# Process monitoring
btop                            # Interactive process viewer
procs                           # Modern ps with colors

# Disk usage
duf                            # Disk usage overview
dust                           # Directory sizes
ncdu                           # Interactive disk usage
```

### Development
```bash
# Git operations
lazygit                        # Interactive git TUI
delta                          # Better git diffs (auto-configured)

# HTTP testing
xh httpbin.org/get             # Fast HTTP requests
gh api user                    # GitHub API calls

# Performance
hyperfine "command"            # Benchmark commands
flamegraph -- ./my-program    # Profile performance
```

### Text Processing
```bash
# JSON/YAML
echo '{"key": "value"}' | jq .
cat file.yaml | yq .key

# Text manipulation  
echo "hello world" | sd "world" "universe"
echo "a,b,c" | choose 1        # Select field (like cut)
```

### Network & Security
```bash
# Network diagnostics
dog example.com                # Modern dig
gping google.com              # Ping with graph
bandwhich                     # Network usage by process

# Security
age -e -r recipient file.txt   # Encrypt file
sops -e secrets.yaml          # Edit encrypted secrets
```

## Environment Variables

Control tool behavior with these environment variables:

```bash
# Tool preferences
export PREFERRED_TOP="btop"     # btop, bottom, or htop
export HIST_TOOL="atuin"        # atuin or mcfly
export BAT_OVERRIDE_LESS=1      # Enable bat as less replacement

# Modern tool aliases (requires modernTools.enable = true)
# Automatically set when enabled in configuration
```

## Configuration Files

Most tools can be configured via dotfiles:

- **Starship**: `~/.config/starship.toml` 
- **Bat**: `~/.config/bat/config`
- **Zellij**: `~/.config/zellij/config.kdl`
- **Helix**: `~/.config/helix/config.toml`
- **Atuin**: `~/.config/atuin/config.toml`

## Getting Help

- Most tools support `--help` and `--version`
- Use `tldr <tool>` for quick examples
- Check tool websites (linked in Nix files) for full documentation
- Many tools have excellent `man` pages

---

*Generated from Nix configuration - run `./generate-cli-docs.sh` to update*
