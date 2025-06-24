#!/usr/bin/env bash
# Comprehensive Nix Configuration Validation
# Tests syntax, flakes, and configuration conflicts

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

# Track validation results
ERRORS=0
WARNINGS=0

# Function to increment error count
error() {
    log_error "$1"
    ((ERRORS++))
}

# Function to increment warning count
warning() {
    log_warning "$1"
    ((WARNINGS++))
}

log_info "Starting comprehensive Nix configuration validation..."

# 1. Check Nix syntax for all .nix files
log_info "Checking Nix syntax for all .nix files..."
NIX_FILES=$(find . -name "*.nix" -not -path "./.git/*" -not -path "./result*")

for file in $NIX_FILES; do
    if ! nix-instantiate --parse "$file" >/dev/null 2>&1; then
        error "Syntax error in $file"
        nix-instantiate --parse "$file" 2>&1 | sed 's/^/  /'
    fi
done

if [ $ERRORS -eq 0 ]; then
    log_success "All Nix files have valid syntax"
fi

# 2. Validate main flake
log_info "Validating main flake..."
if nix flake check --extra-experimental-features "nix-command flakes" 2>/dev/null; then
    log_success "Main flake validation passed"
else
    error "Main flake validation failed"
    nix flake check --extra-experimental-features "nix-command flakes" 2>&1 | sed 's/^/  /'
fi

# 3. Validate CI flake
log_info "Validating CI flake..."
if (cd .github && nix flake check --extra-experimental-features "nix-command flakes" 2>/dev/null); then
    log_success "CI flake validation passed"
else
    error "CI flake validation failed"
    (cd .github && nix flake check --extra-experimental-features "nix-command flakes" 2>&1) | sed 's/^/  /'
fi

# 4. Check for alias conflicts
log_info "Checking for shell alias conflicts..."
ALIAS_FILE=$(mktemp)
grep -h "environment.shellAliases" modules/**/*.nix 2>/dev/null | grep -E '^\s*[a-zA-Z0-9_-]+\s*=' | sort > "$ALIAS_FILE" || true

if [ -s "$ALIAS_FILE" ]; then
    # Check for duplicate alias names with different values
    DUPLICATES=$(cut -d'=' -f1 "$ALIAS_FILE" | sort | uniq -d)
    if [ -n "$DUPLICATES" ]; then
        warning "Found potential alias conflicts:"
        for alias in $DUPLICATES; do
            echo "  Alias '$alias' defined multiple times:"
            grep "^\\s*$alias\\s*=" modules/**/*.nix | sed 's/^/    /'
        done
    else
        log_success "No alias conflicts detected"
    fi
else
    log_success "No shell aliases found to check"
fi
rm -f "$ALIAS_FILE"

# 5. Check for environment variable conflicts
log_info "Checking for environment variable conflicts..."
ENV_FILE=$(mktemp)
grep -h -A 20 "environment.variables" modules/**/*.nix 2>/dev/null | grep -E '^\s*[A-Z_]+\s*=' | sort > "$ENV_FILE" || true

if [ -s "$ENV_FILE" ]; then
    ENV_DUPLICATES=$(cut -d'=' -f1 "$ENV_FILE" | sort | uniq -d)
    if [ -n "$ENV_DUPLICATES" ]; then
        warning "Found potential environment variable conflicts:"
        for var in $ENV_DUPLICATES; do
            echo "  Variable '$var' defined multiple times:"
            grep -r "^\\s*$var\\s*=" modules/ | sed 's/^/    /'
        done
    else
        log_success "No environment variable conflicts detected"
    fi
else
    log_success "No environment variables found to check"
fi
rm -f "$ENV_FILE"

# 6. Test build (dry-run)
log_info "Testing configuration build (dry-run)..."
if nix build .#darwinConfigurations.bleuprint.system --dry-run --extra-experimental-features "nix-command flakes" 2>/dev/null; then
    log_success "Main configuration builds successfully"
else
    error "Main configuration build failed"
    nix build .#darwinConfigurations.bleuprint.system --dry-run --extra-experimental-features "nix-command flakes" 2>&1 | sed 's/^/  /'
fi

# 7. Test CI build (dry-run)
log_info "Testing CI configuration build (dry-run)..."
if (cd .github && nix build .#darwinConfigurations.bleuprint.system --dry-run --extra-experimental-features "nix-command flakes" 2>/dev/null); then
    log_success "CI configuration builds successfully"
else
    error "CI configuration build failed"
    (cd .github && nix build .#darwinConfigurations.bleuprint.system --dry-run --extra-experimental-features "nix-command flakes" 2>&1) | sed 's/^/  /'
fi

# 8. Check for missing package references
log_info "Checking for common package reference issues..."
COMMON_ISSUES=("python313Packages.tensorflow" "apache-spark" "plotly" "polars")
for issue in "${COMMON_ISSUES[@]}"; do
    if grep -r "$issue" modules/ >/dev/null 2>&1; then
        FILES=$(grep -r "$issue" modules/ | cut -d: -f1 | sort -u)
        warning "Found potentially problematic package reference '$issue' in: $FILES"
    fi
done

# 9. Validate justfile commands
if [ -f "justfile" ]; then
    log_info "Validating justfile syntax..."
    if just --list >/dev/null 2>&1; then
        log_success "Justfile syntax is valid"
    else
        error "Justfile has syntax errors"
        just --list 2>&1 | sed 's/^/  /'
    fi
fi

# Summary
echo ""
log_info "=== VALIDATION SUMMARY ==="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    log_success "✅ All validations passed! Configuration is ready."
    exit 0
elif [ $ERRORS -eq 0 ]; then
    log_warning "⚠️  Validation completed with $WARNINGS warnings (no errors)"
    exit 0
else
    log_error "❌ Validation failed with $ERRORS errors and $WARNINGS warnings"
    exit 1
fi 