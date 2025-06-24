# CLI Tools Cheatsheet

Quick reference for the 100+ CLI tools included in this setup.

## ⚙️ Configuration Modes

### Default Mode (modernTools.enable = false)
- Traditional commands work normally
- Modern tools available with their original names or shortcuts:
  - `e` → eza, `b` → bat, `rg` → ripgrep, `f` → fd

### Modern Mode (modernTools.enable = true)
- Traditional commands replaced with modern alternatives
- Original commands still available via full path (e.g., `/bin/ls`)
- Alternative tools available with suffix: `ls2` → lsd, `tree2` → broot

## 🔍 Finding Things

```bash
# Find files by name (fast)
fd pattern
fd -e rs           # Find all Rust files
fd -H pattern      # Include hidden files

# Search file contents
rg "pattern"       # Search in current dir
rg -i "pattern"    # Case insensitive
rg -t py "TODO"    # Search only Python files

# Fuzzy find anything
fzf                # Interactive file picker
ls | fzf           # Fuzzy filter any list
history | fzf      # Find command in history
```

## 📁 File Management

```bash
# Modern ls (multiple options)
eza                # Basic listing
eza -la            # Detailed with hidden
eza --tree         # Tree view
eza --icons        # With file icons

lsd                # Alternative with icons by default
lsd -la            # Long format with hidden files

# Better tree
erd                # Modern tree alternative
erd -H             # Include hidden files
erd -l             # Long format with details

# File navigation
broot              # Interactive tree navigation
br                 # Short alias for broot

# Disk usage
duf                # Pretty disk free
dust               # Visual directory sizes
dust -d 2          # Limit depth
ncdu               # Interactive disk usage

# View files
bat file.txt       # Syntax highlighted cat
bat -n file.txt    # With line numbers
```

## 🚀 Productivity

```bash
# Quick navigation
z partial-path     # Jump to directory
zi                 # Interactive directory jump

# Quick help
tldr tar           # Simple examples for tar
tldr --list        # List all available pages

# Process management
procs              # Modern ps
procs python       # Filter by name
btop               # Beautiful system monitor
```

## 🔧 Development

```bash
# Git helpers
lazygit            # Full Git TUI
gitui              # Alternative Git TUI
git diff | delta   # Better diffs

# HTTP requests
http GET api.com   # Simple GET
http POST api.com name=value  # POST with data
xh api.com         # Faster alternative

# JSON/YAML
echo '{"a":1}' | jq '.'     # Pretty print JSON
cat file.yml | yq '.'       # Process YAML
echo '{"a":1}' | gron       # Make JSON greppable
```

## 📝 Text Processing

```bash
# Find and replace
sd 'old' 'new' file.txt     # Simple replace
sd -i 'old' 'new' *.txt     # In-place multiple files

# Better cut
echo "a,b,c" | choose 1     # Select 2nd field
echo "a b c" | choose -1    # Last field
```

## 🌐 Network

```bash
# DNS queries
dog example.com    # Modern dig
dog example.com A  # Specific record type

# Network path
mtr google.com     # Traceroute + ping

# Ping with graph
gping google.com   # Visual ping
```

## ⚡ Performance

```bash
# Benchmark commands
hyperfine 'cmd1' 'cmd2'     # Compare performance
hyperfine --warmup 3 'cmd'  # With warmup runs

# Watch for changes
watchexec -e py pytest      # Run tests on Python file changes
watchexec -r 'make build'   # Restart on any change
```

## 💡 Shell Enhancements

```bash
# Better history (multiple options)
# With atuin:
Ctrl+R             # Fuzzy search history
Up/Down            # Search with current prefix

# With mcfly:
Ctrl+R             # Smart neural network based history

# Directory env (automatic with direnv)
echo "export FOO=bar" > .envrc
direnv allow       # Approve the env file

# Alternative fuzzy finder
sk                 # skim - Rust-based fzf alternative
ls | sk            # Fuzzy filter any list
```

## 🔒 Security Tools

```bash
# Modern encryption
age -e -r RECIPIENT file.txt > file.age  # Encrypt
age -d -i key.txt file.age > file.txt   # Decrypt

# Secrets management
sops -e secrets.yaml       # Encrypt YAML
sops -d secrets.yaml       # Decrypt YAML

# YubiKey
ykman info                 # Show YubiKey info
ykman oath accounts list   # List OATH accounts
```

## 🎨 Additional Tools

```bash
# Regex from examples
grex "abc" "abd" "acd"     # Generate regex matching all

# Hex viewer
hexyl file.bin             # Beautiful hex display

# Color manipulation
pastel color ff0000        # Analyze color
pastel mix red blue        # Mix colors

# Code to image
silicon main.rs -o code.png # Generate code screenshot

# Terminal workspace
zellij                     # Modern tmux alternative
zellij attach              # Attach to session
```

## 🎯 Quick Tips

1. Most tools support `--help` or `-h` for options
2. Use `man toolname` for detailed documentation
3. Pipe any list to `fzf` for interactive filtering
4. Use `Ctrl+T` in shell to fuzzy-find files
5. Use `Alt+C` in shell to fuzzy-change directories 