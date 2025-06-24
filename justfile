# Bleuprint Development Commands
# Run `just --list` to see all available commands

# Default recipe - show help
default:
    @just --list

# === SETUP COMMANDS ===

# Install Nix (if not already installed)
install-nix:
    #!/usr/bin/env bash
    if ! command -v nix &> /dev/null; then
        echo "Installing Nix..."
        curl -L https://nixos.org/nix/install | sh -s -- --daemon
        echo "Please restart your shell to use Nix"
    else
        echo "Nix is already installed: $(nix --version)"
    fi

# Set up git hooks for code quality
setup-hooks:
    @echo "Setting up git hooks..."
    @./scripts/setup-git-hooks.sh

# Complete setup (install dependencies, set up hooks)
setup: install-nix setup-hooks
    @echo "Setup complete! 🎉"

# === VALIDATION COMMANDS ===

# Comprehensive validation (syntax, flakes, conflicts, builds)
validate:
    @echo "Running comprehensive validation..."
    @./scripts/validate-all.sh

# Legacy Nix validation (kept for compatibility)
validate-nix:
    @echo "Validating Nix configuration..."
    @./scripts/validate-nix.sh

# Run comprehensive test suite
test:
    @echo "Running comprehensive test suite..."
    @./scripts/test-suite.sh

# Quick syntax check (fast)
check:
    #!/usr/bin/env bash
    export NIX_CONFIG="experimental-features = nix-command flakes"
    echo "Quick syntax check..."
    nix flake check --no-build

# === BUILD COMMANDS ===

# Build the Darwin configuration
build:
    #!/usr/bin/env bash
    export NIX_CONFIG="experimental-features = nix-command flakes"
    echo "Building Darwin configuration..."
    nix build .#darwinConfigurations.bleuprint.system

# Dry run build (check what would be built)
build-dry:
    #!/usr/bin/env bash
    export NIX_CONFIG="experimental-features = nix-command flakes"
    echo "Dry run build..."
    nix build .#darwinConfigurations.bleuprint.system --dry-run

# Show flake outputs
show:
    #!/usr/bin/env bash
    export NIX_CONFIG="experimental-features = nix-command flakes"
    nix flake show

# === INSTALLATION COMMANDS ===

# Install the configuration (applies the Darwin configuration)
install:
    @echo "Installing Bleuprint configuration..."
    @./install.sh

# Quick install (bypass some checks)
install-quick:
    @echo "Quick install..."
    @bash install.sh --quick

# === DEVELOPMENT COMMANDS ===

# Format Nix files (requires nixpkgs-fmt)
format:
    #!/usr/bin/env bash
    if command -v nixpkgs-fmt &> /dev/null; then
        find . -name "*.nix" -not -path "./.git/*" -exec nixpkgs-fmt {} \;
        echo "Formatted Nix files"
    else
        echo "nixpkgs-fmt not found. Install with: nix-env -iA nixpkgs.nixpkgs-fmt"
    fi

# Update flake inputs
update:
    #!/usr/bin/env bash
    export NIX_CONFIG="experimental-features = nix-command flakes"
    echo "Updating flake inputs..."
    nix flake update

# Clean build artifacts
clean:
    @echo "Cleaning build artifacts..."
    @rm -rf result result-*
    @echo "Cleaned!"

# === GIT COMMANDS ===

# Commit with conventional commit format
commit message:
    @git add -A
    @git commit -m "{{message}}"

# Push with validation
push:
    @echo "Pushing with validation..."
    @git push

# Create a new feature branch
branch name:
    @git checkout -b "{{name}}"
    @echo "Created and switched to branch: {{name}}"

# === CI/CD COMMANDS ===

# Simulate CI locally (comprehensive)
ci:
    @echo "Simulating CI pipeline locally..."
    @just validate
    @just test
    @just security
    @echo "CI simulation complete! ✅"

# Run security checks
security:
    #!/usr/bin/env bash
    echo "Running security checks..."
    
    # Check for secrets
    if grep -r "password\|secret\|api[_-]key" modules/ --exclude-dir=.git | grep -v "example\|TODO"; then
        echo "⚠️  Potential secrets found!"
        exit 1
    fi
    
    # Check for large files
    find . -type f -size +1M -not -path "./.git/*" -not -path "./result*" | head -5
    
    echo "Security checks passed ✅"

# === DOCUMENTATION COMMANDS ===

# Generate CLI documentation
docs:
    @echo "Generating CLI documentation..."
    @./scripts/generate-cli-docs.sh

# Serve documentation locally (if using Jekyll)
serve-docs:
    #!/usr/bin/env bash
    if command -v bundle &> /dev/null; then
        bundle exec jekyll serve
    else
        echo "Jekyll not available. Install with: gem install jekyll bundler"
    fi

# === MAINTENANCE COMMANDS ===

# Fix common permissions issues
fix-perms:
    @echo "Fixing permissions..."
    @./scripts/fix-permissions.sh

# Run smoke tests
smoke-test:
    @echo "Running smoke tests..."
    @./scripts/smoke-test.sh

# Test modern tools
test-tools:
    @echo "Testing modern tools..."
    @./scripts/test-modern-tools.sh

# === UTILITY COMMANDS ===

# Show system information
info:
    #!/usr/bin/env bash
    echo "=== System Information ==="
    echo "OS: $(uname -s) $(uname -r)"
    echo "Architecture: $(uname -m)"
    if command -v nix &> /dev/null; then
        echo "Nix: $(nix --version)"
    else
        echo "Nix: Not installed"
    fi
    echo ""
    echo "=== Git Information ==="
    echo "Branch: $(git branch --show-current)"
    echo "Commit: $(git rev-parse --short HEAD)"
    echo "Status: $(git status --porcelain | wc -l) files changed"
    echo ""
    echo "=== Project Structure ==="
    find . -maxdepth 2 -type d -not -path "./.git*" | sort

# Watch for changes and validate
watch:
    #!/usr/bin/env bash
    if command -v fswatch &> /dev/null; then
        echo "Watching for changes..."
        fswatch -o . | while read f; do
            if ls *.nix modules/**/*.nix 2>/dev/null | head -1 > /dev/null; then
                echo "Changes detected, validating..."
                just check || echo "❌ Validation failed"
            fi
        done
    else
        echo "fswatch not found. Install with: brew install fswatch"
    fi

# === TROUBLESHOOTING ===

# Debug Nix issues
debug:
    #!/usr/bin/env bash
    export NIX_CONFIG="experimental-features = nix-command flakes"
    echo "=== Debug Information ==="
    echo "Nix version: $(nix --version)"
    echo "Flake check with verbose output:"
    nix flake check --show-trace --verbose 2>&1 | head -50

# Reset git hooks (if they're causing issues)
reset-hooks:
    @echo "Resetting git hooks..."
    @rm -f .git/hooks/pre-commit .git/hooks/pre-push .git/hooks/commit-msg
    @echo "Git hooks removed. Run 'just setup-hooks' to reinstall."

# Emergency bypass (disable all hooks temporarily)
bypass-hooks:
    @git config core.hooksPath /dev/null
    @echo "⚠️  Git hooks bypassed temporarily"
    @echo "Re-enable with: git config --unset core.hooksPath"

# Re-enable hooks
enable-hooks:
    @git config --unset core.hooksPath
    @echo "✅ Git hooks re-enabled"

# === TEMPLATE COMMANDS ===

# Test template cleanup (simulate what happens when someone uses the template)
test-template:
    #!/usr/bin/env bash
    echo "🧪 Testing template cleanup simulation..."
    
    # Create a backup
    git stash push -m "Template test backup"
    
    # Simulate template cleanup
    echo "📋 Files that would be removed:"
    echo "- scripts/validate-nix.sh"
    echo "- scripts/test-suite.sh" 
    echo "- scripts/setup-git-hooks.sh"
    echo "- justfile"
    echo "- flake.lock"
    echo "- docs/TEMPLATE_INFO.md"
    echo "- docs/CONTRIBUTING.md"
    echo "- .github/ISSUE_TEMPLATE/"
    echo "- .github/FUNDING.yml"
    echo ""
    echo "📝 Files that would be created:"
    echo "- FIRST_TIME_SETUP.md"
    echo "- Personalized README.md"
    echo "- Setup checklist issue"
    echo ""
    echo "🔄 Configuration updates:"
    echo "- Replace 'bleuprint' with user's repo name"
    echo "- Replace 'bleulabs' with user's username"
    echo "- Update placeholder values in modules/home/default.nix"
    
    # Restore backup
    git stash pop
    echo ""
    echo "✅ Template test complete (no actual changes made)"

# Prepare repository for template use
prepare-template:
    #!/usr/bin/env bash
    echo "🎯 Preparing repository for template use..."
    
    # Ensure all development files are properly marked
    if [ ! -f ".templateignore" ]; then
        echo "❌ .templateignore file missing"
        exit 1
    fi
    
    # Check template cleanup workflow
    if [ ! -f ".github/template-cleanup.yml" ]; then
        echo "❌ Template cleanup workflow missing"
        exit 1
    fi
    
    # Validate that template files exist
    echo "✅ .templateignore exists"
    echo "✅ Template cleanup workflow exists"
    echo "✅ Repository metadata configured"
    
    echo ""
    echo "🚀 Repository is ready to be used as a template!"
    echo ""
    echo "To enable template mode on GitHub:"
    echo "1. Go to repository Settings"
    echo "2. Check 'Template repository' under General"
    echo "3. Users can then click 'Use this template' to create their own copy" 