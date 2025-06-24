#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if running in CI
if [[ "${CI:-false}" == "true" ]]; then
    log_info "Running in CI environment"
    EXTRA_FLAGS="--extra-experimental-features nix-command --extra-experimental-features flakes"
else
    log_info "Running locally"
    EXTRA_FLAGS="--extra-experimental-features nix-command --extra-experimental-features flakes"
fi

# Ensure we're in the right directory
cd "$(dirname "$0")/.."

log_info "Starting Nix configuration validation..."

# 1. Check flake syntax
log_info "Checking flake syntax..."
if nix $EXTRA_FLAGS flake check --no-build 2>&1; then
    log_success "Flake syntax is valid"
else
    log_error "Flake syntax check failed"
    exit 1
fi

# 2. Check if flake can be evaluated
log_info "Evaluating flake outputs..."
if nix $EXTRA_FLAGS flake show 2>&1; then
    log_success "Flake evaluation successful"
else
    log_error "Flake evaluation failed"
    exit 1
fi

# 3. Test build for different systems
log_info "Testing builds for different systems..."

# Get current system
CURRENT_SYSTEM=$(nix $EXTRA_FLAGS eval --impure --raw --expr 'builtins.currentSystem')
log_info "Current system: $CURRENT_SYSTEM"

# Test build for current system
log_info "Testing build for $CURRENT_SYSTEM..."
if nix $EXTRA_FLAGS build ".#darwinConfigurations.bleuprint.system" --dry-run 2>&1; then
    log_success "Build test passed for $CURRENT_SYSTEM"
else
    log_error "Build test failed for $CURRENT_SYSTEM"
    exit 1
fi

# 4. Validate Nix files syntax
log_info "Validating individual Nix files..."
find . -name "*.nix" -not -path "./.git/*" -not -path "./result*" | while read -r file; do
    log_info "Checking $file..."
    if nix $EXTRA_FLAGS eval --file "$file" --json >/dev/null 2>&1; then
        log_success "✓ $file"
    else
        log_error "✗ $file has syntax errors"
        exit 1
    fi
done

# 5. Check for common issues
log_info "Checking for common configuration issues..."

# Check for unquoted attribute names starting with dots
if grep -r "^\s*\.\." modules/ --include="*.nix" 2>/dev/null; then
    log_error "Found unquoted dot attributes (should be quoted)"
    exit 1
fi

# Check for missing semicolons at end of attribute sets
if grep -r "}\s*$" modules/ --include="*.nix" | grep -v ";\s*}\s*$" >/dev/null 2>&1; then
    log_warning "Potential missing semicolons found (manual review recommended)"
fi

# 6. Test home-manager configuration if present
if nix $EXTRA_FLAGS eval ".#darwinConfigurations.bleuprint.config.home-manager" --raw 2>/dev/null; then
    log_info "Testing home-manager configuration..."
    if nix $EXTRA_FLAGS build ".#darwinConfigurations.bleuprint.config.home-manager.users" --dry-run 2>&1; then
        log_success "Home-manager configuration is valid"
    else
        log_error "Home-manager configuration has issues"
        exit 1
    fi
fi

log_success "All Nix validation checks passed! 🎉" 