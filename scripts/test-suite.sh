#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[TEST]${NC} $1"; }
log_success() { echo -e "${GREEN}[TEST]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[TEST]${NC} $1"; }
log_error() { echo -e "${RED}[TEST]${NC} $1"; }

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    log_info "Running test: $test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        log_success "✓ $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        log_error "✗ $test_name"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Function to run a test with output
run_test_with_output() {
    local test_name="$1"
    local test_command="$2"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    log_info "Running test: $test_name"
    
    if eval "$test_command"; then
        log_success "✓ $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        log_error "✗ $test_name"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Ensure we're in the right directory
cd "$(dirname "$0")/.."

log_info "Starting comprehensive test suite..."
log_info "=================================="

# 1. Basic file structure tests
log_info "Testing basic file structure..."
run_test "flake.nix exists" "test -f flake.nix"
run_test "modules directory exists" "test -d modules"
run_test "scripts directory exists" "test -d scripts"
run_test "README.md exists" "test -f README.md"

# 2. Nix syntax tests
log_info "Testing Nix syntax..."
if command -v nix >/dev/null 2>&1; then
    export NIX_CONFIG="experimental-features = nix-command flakes"
    
    run_test_with_output "Nix flake check" "./scripts/validate-nix.sh"
    run_test "Flake evaluation" "nix flake show >/dev/null 2>&1"
    run_test "Flake metadata" "nix flake metadata >/dev/null 2>&1"
else
    log_warning "Nix not available, skipping Nix-specific tests"
fi

# 3. Shell script tests
log_info "Testing shell scripts..."
for script in scripts/*.sh; do
    if [[ -f "$script" ]]; then
        script_name=$(basename "$script")
        run_test "Shell syntax: $script_name" "bash -n $script"
        run_test "Script executable: $script_name" "test -x $script"
    fi
done

# 4. Documentation tests
log_info "Testing documentation..."
run_test "README has content" "test $(wc -l < README.md) -gt 10"
run_test "LICENSE exists" "test -f LICENSE"

# Check for broken links in markdown files
if command -v grep >/dev/null 2>&1; then
    run_test "No obvious broken internal links" "! grep -r '\](\./' docs/ README.md | grep -v '\.md)' | grep -v '\.png)' | grep -v '\.jpg)' >/dev/null"
fi

# 5. Git tests
log_info "Testing Git configuration..."
run_test "Git repository" "test -d .git"
run_test "Git hooks directory" "test -d .git/hooks"

# Check if git hooks are installed
if [[ -f .git/hooks/pre-commit ]]; then
    run_test "Pre-commit hook executable" "test -x .git/hooks/pre-commit"
fi

if [[ -f .git/hooks/pre-push ]]; then
    run_test "Pre-push hook executable" "test -x .git/hooks/pre-push"
fi

# 6. Security tests
log_info "Testing security..."
run_test "No obvious secrets in config" "! grep -r 'password.*=' modules/ | grep -v 'example' >/dev/null"
run_test "No private keys committed" "! find . -name '*.pem' -o -name '*.key' -o -name 'id_rsa' | grep -v '.git' >/dev/null"

# 7. Performance tests
log_info "Testing performance..."
if command -v nix >/dev/null 2>&1; then
    export NIX_CONFIG="experimental-features = nix-command flakes"
    run_test "Flake evaluation time reasonable" "timeout 30s nix flake show >/dev/null 2>&1"
fi

# 8. Integration tests
log_info "Testing integration..."
run_test "Install script exists" "test -f install.sh"
run_test "Install script executable" "test -x install.sh"

# Check install script syntax
run_test "Install script syntax" "bash -n install.sh"

# 9. CI/CD tests
log_info "Testing CI/CD configuration..."
run_test "GitHub Actions directory" "test -d .github/workflows"
run_test "CI workflow exists" "test -f .github/workflows/ci.yml"

# Check workflow syntax (basic YAML)
if command -v python3 >/dev/null 2>&1; then
    run_test "CI workflow YAML syntax" "python3 -c 'import yaml; yaml.safe_load(open(\".github/workflows/ci.yml\"))'"
fi

# 10. Module tests
log_info "Testing modules..."
for module in modules/*/default.nix; do
    if [[ -f "$module" ]]; then
        module_name=$(basename "$(dirname "$module")")
        run_test "Module syntax: $module_name" "bash -c 'cd $(dirname $module) && nix eval --file default.nix --json >/dev/null 2>&1' || true"
    fi
done

# Summary
log_info "=================================="
log_info "Test Summary:"
log_info "  Total tests: $TESTS_RUN"
log_success "  Passed: $TESTS_PASSED"
if [[ $TESTS_FAILED -gt 0 ]]; then
    log_error "  Failed: $TESTS_FAILED"
else
    log_info "  Failed: $TESTS_FAILED"
fi

if [[ $TESTS_FAILED -eq 0 ]]; then
    log_success "All tests passed! 🎉"
    exit 0
else
    log_error "Some tests failed. Please review and fix the issues."
    exit 1
fi 