#!/usr/bin/env bash
# Setup script for optional Git security hooks

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo -e "${BLUE}🔒 Git Security Hooks Setup${NC}"
echo "============================"
echo ""
echo "This script will set up optional Git hooks to prevent accidentally"
echo "pushing sensitive information to public repositories."
echo ""

# Check if hooks directory exists
if [ ! -d ".githooks" ]; then
    echo -e "${RED}Error: .githooks directory not found${NC}"
    echo "Make sure you're in the repository root directory."
    exit 1
fi

# Check if pre-push hook exists
if [ ! -f ".githooks/pre-push" ]; then
    echo -e "${RED}Error: .githooks/pre-push not found${NC}"
    echo "The pre-push hook file is missing."
    exit 1
fi

echo -e "${YELLOW}⚠️  Security Hook Features:${NC}"
echo "• Scans for email addresses, SSH keys, API tokens"
echo "• Detects real names in Git configuration"
echo "• Blocks pushes to public repos if sensitive data found"
echo "• Fully customizable patterns and exclusions"
echo "• Can be bypassed with --no-verify if needed"
echo ""

read -p "Do you want to enable Git security hooks? (y/n) [y]: " ENABLE_HOOKS
ENABLE_HOOKS=${ENABLE_HOOKS:-y}

if [[ ! "$ENABLE_HOOKS" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Git hooks not enabled.${NC}"
    echo ""
    echo "To enable later, run: ./setup-git-hooks.sh"
    exit 0
fi

# Make the hook executable
chmod +x .githooks/pre-push

# Configure Git to use the hooks directory
git config core.hooksPath .githooks

echo -e "${GREEN}✅ Git security hooks enabled!${NC}"
echo ""

# Check if this looks like a public repository
echo -e "${BLUE}🔍 Checking repository visibility...${NC}"
REMOTE_URL=$(git config --get remote.origin.url 2>/dev/null || echo "")

if [[ "$REMOTE_URL" == *"github.com"* ]]; then
    echo -e "${YELLOW}⚠️  GitHub repository detected${NC}"
    echo "Repository: $REMOTE_URL"
    echo ""
    echo -e "${RED}🚨 IMPORTANT SECURITY WARNING:${NC}"
    echo ""
    echo "If this is a PUBLIC repository, be extra careful about:"
    echo "• Personal email addresses"
    echo "• Real names in configuration"
    echo "• SSH keys or GPG keys"
    echo "• API tokens or passwords"
    echo "• Internal hostnames or network info"
    echo ""
    echo "The Git hook will help catch these, but manual review is still important!"
    echo ""
    read -p "Press Enter to continue..."
fi

echo -e "${BLUE}📝 Customization Options:${NC}"
echo ""
echo "You can customize the security patterns by editing:"
echo "  .githooks/pre-push"
echo ""
echo "To disable hooks later:"
echo "  git config core.hooksPath ''"
echo ""
echo "To bypass hook for one push (NOT recommended for public repos):"
echo "  git push --no-verify"
echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo "The security hook will run automatically on your next push." 

# Ensure we're in the git root
cd "$(git rev-parse --show-toplevel)"

log_info "Setting up git hooks for code quality..."

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[PRE-COMMIT]${NC} $1"; }
log_success() { echo -e "${GREEN}[PRE-COMMIT]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[PRE-COMMIT]${NC} $1"; }
log_error() { echo -e "${RED}[PRE-COMMIT]${NC} $1"; }

log_info "Running pre-commit validation..."

# Check if we have staged files
if ! git diff --cached --quiet; then
    log_info "Found staged changes, running validation..."
    
    # Get list of staged files
    STAGED_FILES=$(git diff --cached --name-only)
    
    # Check if any Nix files are staged
    if echo "$STAGED_FILES" | grep -q "\.nix$"; then
        log_info "Nix files detected in staging area, running validation..."
        
        # Run Nix validation
        if ./scripts/validate-nix.sh; then
            log_success "Nix validation passed"
        else
            log_error "Nix validation failed. Please fix the issues before committing."
            exit 1
        fi
    fi
    
    # Check for common issues in staged files
    log_info "Checking for common issues..."
    
    # Check for debug statements
    if echo "$STAGED_FILES" | xargs grep -l "console\.log\|debugger\|TODO.*REMOVE" 2>/dev/null; then
        log_warning "Found debug statements or TODO REMOVE comments"
        echo "Files with issues:"
        echo "$STAGED_FILES" | xargs grep -l "console\.log\|debugger\|TODO.*REMOVE" 2>/dev/null || true
        echo "Please remove debug statements before committing"
        exit 1
    fi
    
    # Check for large files (>1MB)
    for file in $STAGED_FILES; do
        if [[ -f "$file" && $(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null) -gt 1048576 ]]; then
            log_error "Large file detected: $file (>1MB)"
            log_error "Please avoid committing large files"
            exit 1
        fi
    done
    
    # Check for secrets or sensitive data
    if echo "$STAGED_FILES" | xargs grep -i "password\|secret\|api[_-]key\|private[_-]key" 2>/dev/null | grep -v "# TODO:\|TODO:\|FIXME:" | head -5; then
        log_error "Potential secrets detected in staged files!"
        log_error "Please review and remove sensitive data before committing"
        exit 1
    fi
    
    log_success "Pre-commit validation passed!"
else
    log_info "No staged changes detected"
fi
EOF

# Create pre-push hook
cat > .git/hooks/pre-push << 'EOF'
#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[PRE-PUSH]${NC} $1"; }
log_success() { echo -e "${GREEN}[PRE-PUSH]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[PRE-PUSH]${NC} $1"; }
log_error() { echo -e "${RED}[PRE-PUSH]${NC} $1"; }

log_info "Running pre-push validation..."

# Run comprehensive tests before pushing
if ./scripts/validate-nix.sh; then
    log_success "All validation checks passed"
else
    log_error "Validation failed. Push aborted."
    exit 1
fi

# Check if we're pushing to main/master
protected_branch='master'
current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

if [[ $current_branch == $protected_branch ]]; then
    log_warning "Pushing to protected branch: $protected_branch"
    log_info "Running additional checks..."
    
    # Ensure we have the latest changes
    git fetch origin $protected_branch
    
    # Check if we're behind
    if ! git merge-base --is-ancestor origin/$protected_branch HEAD; then
        log_error "Your branch is behind origin/$protected_branch"
        log_error "Please pull the latest changes first: git pull origin $protected_branch"
        exit 1
    fi
fi

log_success "Pre-push validation completed successfully!"
EOF

# Create commit-msg hook for conventional commits
cat > .git/hooks/commit-msg << 'EOF'
#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[COMMIT-MSG]${NC} $1"; }
log_success() { echo -e "${GREEN}[COMMIT-MSG]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[COMMIT-MSG]${NC} $1"; }
log_error() { echo -e "${RED}[COMMIT-MSG]${NC} $1"; }

commit_regex='^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)(\(.+\))?: .{1,50}'

if ! grep -qE "$commit_regex" "$1"; then
    log_error "Invalid commit message format!"
    log_info "Commit messages should follow conventional commits format:"
    log_info "  <type>[optional scope]: <description>"
    log_info ""
    log_info "Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert"
    log_info ""
    log_info "Examples:"
    log_info "  feat: add new module for development tools"
    log_info "  fix(nix): resolve syntax error in home configuration"
    log_info "  docs: update README with installation instructions"
    log_info "  chore: update dependencies"
    exit 1
fi

log_success "Commit message format is valid"
EOF

# Make hooks executable
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/pre-push
chmod +x .git/hooks/commit-msg

log_success "Git hooks installed successfully!"
log_info "Hooks installed:"
log_info "  • pre-commit: Validates Nix files and checks for common issues"
log_info "  • pre-push: Runs comprehensive validation before pushing"
log_info "  • commit-msg: Enforces conventional commit message format"

# Test the hooks
log_info "Testing git hooks..."
if [[ -x .git/hooks/pre-commit ]]; then
    log_success "✓ pre-commit hook is executable"
else
    log_error "✗ pre-commit hook is not executable"
fi

if [[ -x .git/hooks/pre-push ]]; then
    log_success "✓ pre-push hook is executable"
else
    log_error "✗ pre-push hook is not executable"
fi

if [[ -x .git/hooks/commit-msg ]]; then
    log_success "✓ commit-msg hook is executable"
else
    log_error "✗ commit-msg hook is not executable"
fi

log_success "Git hooks setup completed! 🎉" 