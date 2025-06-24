#!/usr/bin/env bash
# Smoke tests for essential tools
# Run after darwin-rebuild to verify setup

set -e

echo "🧪 Running smoke tests..."
echo ""

# Test: Nix-Darwin
echo "✓ Testing Nix-Darwin..."
if darwin-rebuild --help > /dev/null 2>&1; then
    echo "  ✅ darwin-rebuild available"
else
    echo "  ❌ darwin-rebuild not found"
    exit 1
fi

# Test: Language runtimes
echo ""
echo "✓ Testing language runtimes..."

# Node.js
if node --version | grep -q "v22"; then
    echo "  ✅ Node.js 22 LTS: $(node --version)"
else
    echo "  ❌ Node.js 22 not found"
fi

# Go
if go version | grep -q "go1.2"; then
    echo "  ✅ Go: $(go version | cut -d' ' -f3)"
else
    echo "  ❌ Go not found"
fi

# Rust
if rustc --version > /dev/null 2>&1; then
    echo "  ✅ Rust: $(rustc --version | cut -d' ' -f2)"
else
    echo "  ❌ Rust not found"
fi

# Python
if python3 --version | grep -q "3.13"; then
    echo "  ✅ Python: $(python3 --version)"
else
    echo "  ❌ Python 3.13 not found"
fi

# Test: Essential tools
echo ""
echo "✓ Testing essential tools..."

# Git
if git --version > /dev/null 2>&1; then
    echo "  ✅ Git: $(git --version | cut -d' ' -f3)"
else
    echo "  ❌ Git not found"
fi

# Docker/Container runtime
if docker --version > /dev/null 2>&1; then
    echo "  ✅ Docker: $(docker --version | cut -d' ' -f3 | tr -d ',')"
elif podman --version > /dev/null 2>&1; then
    echo "  ✅ Podman: $(podman --version | cut -d' ' -f3)"
else
    echo "  ⚠️  No container runtime found (Docker/Podman)"
fi

# GitHub CLI
if gh --version > /dev/null 2>&1; then
    echo "  ✅ GitHub CLI: $(gh --version | head -n1 | cut -d' ' -f3)"
else
    echo "  ❌ GitHub CLI not found"
fi

# Test: CLI tools
echo ""
echo "✓ Testing CLI tools..."

tools=(
    "rg:ripgrep"
    "fd:fd"
    "bat:bat"
    "eza:eza"
    "fzf:fzf"
    "tmux:tmux"
    "nvim:neovim"
    "jq:jq"
    "btop:btop"
    "hyperfine:hyperfine"
)

for tool_spec in "${tools[@]}"; do
    cmd="${tool_spec%%:*}"
    name="${tool_spec##*:}"
    if command -v "$cmd" > /dev/null 2>&1; then
        echo "  ✅ $name"
    else
        echo "  ❌ $name not found"
    fi
done

# Test: Performance benchmark
echo ""
echo "✓ Running performance test..."
if command -v hyperfine > /dev/null 2>&1; then
    echo "  Running quick benchmark..."
    hyperfine --warmup 3 --runs 5 \
        'node -e "console.log(1+1)"' \
        'python3 -c "print(1+1)"' \
        2>/dev/null || echo "  ⚠️  Benchmark failed"
else
    echo "  ⚠️  hyperfine not available for benchmarking"
fi

# Test: Container runtime
echo ""
echo "✓ Testing container runtime..."
if command -v docker > /dev/null 2>&1; then
    if docker run --rm hello-world > /dev/null 2>&1; then
        echo "  ✅ Docker runtime working"
    else
        echo "  ⚠️  Docker installed but not running"
    fi
elif command -v podman > /dev/null 2>&1; then
    if podman run --rm hello-world > /dev/null 2>&1; then
        echo "  ✅ Podman runtime working"
    else
        echo "  ⚠️  Podman installed but not initialized"
    fi
fi

# Test: Homebrew
echo ""
echo "✓ Testing Homebrew..."
if brew doctor > /dev/null 2>&1; then
    echo "  ✅ Homebrew: Your system is ready"
else
    echo "  ⚠️  Homebrew has issues: run 'brew doctor'"
fi

echo ""
echo "🎉 Smoke tests complete!"
echo ""
echo "💡 Next steps:"
echo "  - Run 'tldr <command>' for quick help"
echo "  - Use 'z <path>' to jump to directories"
echo "  - Press Ctrl+R for fuzzy command history"
echo "  - Run 'lazygit' for visual Git operations" 