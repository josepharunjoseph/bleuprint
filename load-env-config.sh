#!/usr/bin/env bash
# Load environment configuration and apply to Nix files

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to load environment variables from .env file
load_env() {
    if [ -f ".env" ]; then
        echo -e "${GREEN}✓ Loading configuration from .env${NC}"
        # Export variables from .env file (ignoring comments and empty lines)
        set -a
        source <(grep -v '^#' .env | grep -v '^$' | sed 's/^/export /')
        set +a
        return 0
    elif [ -f ".env.local" ]; then
        echo -e "${GREEN}✓ Loading configuration from .env.local${NC}"
        set -a
        source <(grep -v '^#' .env.local | grep -v '^$' | sed 's/^/export /')
        set +a
        return 0
    else
        echo -e "${YELLOW}⚠ No .env file found${NC}"
        echo "Create one from the template: cp .env.example .env"
        return 1
    fi
}

# Apply Git configuration
apply_git_config() {
    if [ -n "$GIT_USER_NAME" ] && [ "$GIT_USER_NAME" != "Your Name" ]; then
        echo -e "${BLUE}Applying Git name: $GIT_USER_NAME${NC}"
        sed -i '' "s/Your Name/$GIT_USER_NAME/g" modules/home/default.nix
    fi
    
    if [ -n "$GIT_USER_EMAIL" ] && [ "$GIT_USER_EMAIL" != "your.email@example.com" ]; then
        echo -e "${BLUE}Applying Git email: $GIT_USER_EMAIL${NC}"
        sed -i '' "s/your.email@example.com/$GIT_USER_EMAIL/g" modules/home/default.nix
    fi
}

# Apply system configuration
apply_system_config() {
    if [ -n "$SYSTEM_HOSTNAME" ] && [ "$SYSTEM_HOSTNAME" != "workstation" ]; then
        echo -e "${BLUE}Applying hostname: $SYSTEM_HOSTNAME${NC}"
        local files_to_update=(
            "flake.nix"
            "bootstrap-mac.sh"
            "smoke-test.sh"
            "README.md"
            "SETUP.md"
            "CONTRIBUTING.md"
            ".github/workflows/ci.yml"
        )
        
        for file in "${files_to_update[@]}"; do
            if [ -f "$file" ]; then
                sed -i '' "s/workstation/$SYSTEM_HOSTNAME/g" "$file"
            fi
        done
    fi
    
    if [ -n "$HOME_MANAGER_USERNAME" ] && [ "$HOME_MANAGER_USERNAME" != "a" ]; then
        echo -e "${BLUE}Applying username: $HOME_MANAGER_USERNAME${NC}"
        sed -i '' "s/home-manager.users.a/home-manager.users.$HOME_MANAGER_USERNAME/g" flake.nix
        sed -i '' "s/users.a/users.$HOME_MANAGER_USERNAME/g" modules/home/default.nix
    fi
}

# Apply modern tools configuration
apply_modern_tools_config() {
    if [ "$ENABLE_MODERN_TOOLS" = "true" ]; then
        echo -e "${BLUE}Enabling modern tool replacements${NC}"
        sed -i '' 's/programs.modernTools.enable = false;/programs.modernTools.enable = true;/g' modules/home/default.nix
    fi
}

# Apply GPG signing configuration
apply_gpg_config() {
    if [ -n "$GPG_SIGNING_KEY" ]; then
        echo -e "${BLUE}Enabling Git commit signing with key: $GPG_SIGNING_KEY${NC}"
        sed -i '' 's/# commit.gpgsign = true;/commit.gpgsign = true;/g' modules/home/default.nix
        sed -i '' "s/# user.signingkey = \"YOUR_GPG_KEY\";/user.signingkey = \"$GPG_SIGNING_KEY\";/g" modules/home/default.nix
    fi
}

# Setup Git hooks if requested
setup_git_hooks() {
    if [ "$ENABLE_GIT_HOOKS" = "true" ]; then
        echo -e "${BLUE}Setting up Git security hooks${NC}"
        if [ -f "./setup-git-hooks.sh" ]; then
            chmod +x ./setup-git-hooks.sh
            # Run non-interactively
            git config core.hooksPath .githooks 2>/dev/null || true
            chmod +x .githooks/pre-push 2>/dev/null || true
            echo -e "${GREEN}✓ Git security hooks enabled${NC}"
        fi
    fi
}

# Exclude Homebrew apps if specified
exclude_homebrew_apps() {
    if [ -n "$EXCLUDE_HOMEBREW_APPS" ]; then
        echo -e "${BLUE}Excluding Homebrew apps: $EXCLUDE_HOMEBREW_APPS${NC}"
        IFS=',' read -ra APPS <<< "$EXCLUDE_HOMEBREW_APPS"
        for app in "${APPS[@]}"; do
            app=$(echo "$app" | xargs)  # trim whitespace
            if [ -f "modules/homebrew/apps.nix" ]; then
                # Comment out the app line
                sed -i '' "s/\"$app\"/# \"$app\"/g" modules/homebrew/apps.nix
            fi
        done
    fi
}

# Main function
main() {
    echo -e "${BLUE}🔧 Environment Configuration Loader${NC}"
    echo "===================================="
    echo ""
    
    # Load environment variables
    if ! load_env; then
        echo ""
        echo -e "${YELLOW}To use environment configuration:${NC}"
        echo "1. Copy the template: cp .env.example .env"
        echo "2. Edit .env with your personal information"
        echo "3. Run this script again: ./load-env-config.sh"
        echo ""
        echo -e "${RED}Note: .env files are automatically ignored by Git${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "${BLUE}Applying configuration...${NC}"
    
    # Apply all configurations
    apply_git_config
    apply_system_config
    apply_modern_tools_config
    apply_gpg_config
    exclude_homebrew_apps
    setup_git_hooks
    
    echo ""
    echo -e "${GREEN}✅ Environment configuration applied!${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  Security reminder:${NC}"
    echo "Your .env file contains sensitive information and is ignored by Git."
    echo "Always review changes before committing: git diff"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Review the applied changes: git diff"
    echo "2. Run the bootstrap: ./bootstrap-mac.sh"
    echo "3. Verify installation: ./smoke-test.sh"
}

# Run main function
main "$@" 