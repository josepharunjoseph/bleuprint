# Configuration Options Reference

This document explains all the configuration options available in your Nix-Darwin setup.

## Modern Tool Replacements

Location: `modules/home/default.nix`

```nix
# Enable to replace traditional commands with modern alternatives
programs.modernTools.enable = true;  # Default: false
```

### What changes when enabled:

| Traditional | Modern Replacement | Features Added |
|------------|-------------------|----------------|
| `ls` | `eza --icons` | Icons, colors, git status |
| `cat` | `bat` | Syntax highlighting, line numbers |
| `grep` | `rg` (ripgrep) | 5-10x faster, respects .gitignore |
| `find` | `fd` | Faster, intuitive syntax |
| `tree` | `erd` | Modern tree with better defaults |
| `top` | `btop` | Beautiful TUI, mouse support |
| `df` | `duf` | Better formatting, colors |
| `du` | `dust` | Visual tree of disk usage |
| `ps` | `procs` | Better formatting, tree view |
| `dig` | `dog` | Colorful, cleaner output |
| `ping` | `gping` | Graph visualization |
| `diff` | `delta` | Side-by-side, syntax highlighting |

### Always available shortcuts (regardless of setting):

- `e` → eza
- `b` → bat
- `rg` → ripgrep
- `f` → fd
- `ls2` → lsd (alternative to eza)
- `tree2` → broot (interactive tree)
- `fzf2` → sk (skim)
- `tmux2` → zellij
- `vim2` → helix

## ML/Data Science Stack

Location: `flake.nix`

```nix
modules = [
  ./modules/system/core.nix
  ./modules/system/cli-utils.nix
  ./modules/system/ml-stack.nix  # Uncomment to enable
  ./modules/homebrew/apps.nix
  # ...
];
```

Adds PyTorch, TensorFlow, Jupyter, pandas, and more.

## Shell History

Two options available (both installed):

### Atuin (default)
- Neural network-based history search
- Syncs across machines (optional)
- Stats and insights

### McFly (alternative)
```nix
# To switch to McFly, edit modules/home/default.nix
# Comment out the Atuin line and uncomment:
# eval "$(${pkgs.mcfly}/bin/mcfly init zsh)"
```

## Git Configuration

Location: `modules/home/default.nix`

```nix
programs.git = {
  userName = "Your Name";        # TODO: Update
  userEmail = "your@email.com";  # TODO: Update
  
  # Optional: Enable commit signing
  extraConfig = {
    commit.gpgsign = true;
    user.signingkey = "YOUR_GPG_KEY";
  };
};
```

## Terminal Emulator

Multiple options installed:
- **Kitty** - GPU accelerated, fast
- **WezTerm** - Highly configurable
- **iTerm2** - Classic Mac terminal

Set your default in System Preferences → Desktop & Dock → Default web browser → Terminal.

## Container Runtime

OrbStack installed by default. To use Podman instead:

```nix
# In modules/homebrew/apps.nix, replace:
"orbstack"
# With:
"podman-desktop"
```

Then run:
```bash
podman machine init
podman machine start
```

## Useful Toggles

### Nix Store Optimization
Already enabled in `modules/system/core.nix`:
```nix
nix.settings = {
  auto-optimise-store = true;  # Deduplicates files
  fsync-metadata = true;       # Safer writes
};
```

### Touch ID for sudo
Already enabled - no configuration needed.

### Directory-specific environments
Already configured with direnv. Create `.envrc` files in projects:
```bash
# Example .envrc
export NODE_ENV=development
export DATABASE_URL=postgresql://localhost/myapp
``` 