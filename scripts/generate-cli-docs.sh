#!/usr/bin/env bash
set -euo pipefail

# Auto-generate CLI_CHEATSHEET.md from Nix configuration
# This ensures documentation never drifts from actual installed tools

echo "🔍 Generating CLI documentation from Nix configuration..."

# Extract tool information from Nix files
generate_tool_list() {
    local file="$1"
    local section="$2"
    
    echo "### $section"
    echo ""
    
    # Extract package names and comments from Nix file
    grep -E '^\s*[a-zA-Z0-9_-]+\s*#' "$file" | while IFS= read -r line; do
        # Extract package name (before #)
        pkg=$(echo "$line" | sed 's/^\s*//' | cut -d'#' -f1 | sed 's/\s*$//' | sed 's/;//')
        # Extract comment (after #)
        comment=$(echo "$line" | cut -d'#' -f2- | sed 's/^\s*//')
        
        if [[ -n "$pkg" && "$pkg" != "pkgs" && "$pkg" != "with" ]]; then
            echo "- **\`$pkg\`** - $comment"
        fi
    done
    echo ""
}

# Start generating the cheatsheet
cat > docs/CLI_CHEATSHEET.md << 'EOF'
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

EOF

# Generate sections from each Nix file
if [[ -f "modules/system/core.nix" ]]; then
    generate_tool_list "modules/system/core.nix" "Core Development Tools" >> docs/CLI_CHEATSHEET.md
fi

if [[ -f "modules/system/cli-utils.nix" ]]; then
    generate_tool_list "modules/system/cli-utils.nix" "CLI Utilities" >> docs/CLI_CHEATSHEET.md
fi

if [[ -f "modules/homebrew/apps.nix" ]]; then
    echo "### GUI Applications (via Homebrew)" >> docs/CLI_CHEATSHEET.md
    echo "" >> docs/CLI_CHEATSHEET.md
    grep -E '^\s*"[^"]*"' modules/homebrew/apps.nix | while IFS= read -r line; do
        app=$(echo "$line" | sed 's/^\s*"//' | sed 's/".*//')
        if [[ -n "$app" ]]; then
            echo "- **$app**" >> docs/CLI_CHEATSHEET.md
        fi
    done
    echo "" >> docs/CLI_CHEATSHEET.md
fi

# Add usage examples
cat >> docs/CLI_CHEATSHEET.md << 'EOF'
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
EOF

echo "✅ docs/CLI_CHEATSHEET.md generated successfully"
echo "📝 $(wc -l < docs/CLI_CHEATSHEET.md) lines of documentation created" 