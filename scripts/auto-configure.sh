#!/usr/bin/env bash
# Interactive configuration script with user consent for each step

set -e

echo "🔧 Interactive Configuration Wizard"
echo "===================================="
echo ""
echo "This wizard will help you configure your dotfiles safely."
echo "You'll be asked to approve each step and can skip anything you don't want."
echo ""
echo -e "${BLUE}💡 Pro tip:${NC} You can also use environment files for configuration!"
echo "  1. Copy .env.example to .env"
echo "  2. Edit .env with your personal information"
echo "  3. Run ./load-env-config.sh to apply automatically"
echo ""
read -p "Continue with interactive wizard? (y/n) [y]: " CONTINUE_WIZARD
CONTINUE_WIZARD=${CONTINUE_WIZARD:-y}

if [[ ! "$CONTINUE_WIZARD" =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}Wizard cancelled.${NC}"
    echo ""
    echo "Alternative configuration methods:"
    echo "• Environment file: cp .env.example .env && ./load-env-config.sh"
    echo "• Manual editing: see CUSTOMIZE_CHECKLIST.md"
    exit 0
fi
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Track if any changes were made
CHANGES_MADE=false

# Check if this is a public repository and warn user
check_and_warn_public_repo() {
    local remote_url
    remote_url=$(git config --get remote.origin.url 2>/dev/null || echo "")
    
    if [[ "$remote_url" == *"github.com"* ]]; then
        echo -e "${RED}🚨 SECURITY WARNING${NC}"
        echo "=================================="
        echo ""
        echo -e "${YELLOW}⚠️  GitHub repository detected:${NC}"
        echo "$remote_url"
        echo ""
        echo -e "${RED}If this is a PUBLIC repository, be extremely careful about:${NC}"
        echo "• Personal email addresses"
        echo "• Real names"
        echo "• SSH keys or GPG keys"
        echo "• API tokens or passwords"
        echo "• Internal hostnames"
        echo ""
        echo -e "${BLUE}This script will ask permission before making any changes.${NC}"
        echo -e "${BLUE}You can review all changes before committing.${NC}"
        echo ""
        read -p "Do you understand the risks and want to continue? (y/n) [n]: " CONTINUE_SETUP
        CONTINUE_SETUP=${CONTINUE_SETUP:-n}
        
        if [[ ! "$CONTINUE_SETUP" =~ ^[Yy]$ ]]; then
            echo ""
            echo -e "${YELLOW}Setup cancelled for security.${NC}"
            echo ""
            echo "To configure manually:"
            echo "1. Edit modules/home/default.nix for Git settings"
            echo "2. Edit flake.nix for hostname and username"
            echo "3. See CUSTOMIZE_CHECKLIST.md for guidance"
            exit 0
        fi
        
        return 0  # Public repo
    fi
    
    return 1  # Not detected as public
}

# Detect and offer to configure Git information
configure_git_info() {
    echo -e "${BLUE}📧 Git Configuration${NC}"
    echo "===================="
    echo ""
    
    # Detect current Git config
    local git_name git_email
    git_name=$(git config --global user.name 2>/dev/null || echo "")
    git_email=$(git config --global user.email 2>/dev/null || echo "")
    
    if [ -n "$git_name" ] && [ -n "$git_email" ]; then
        echo -e "${GREEN}✓ Detected Git configuration:${NC}"
        echo "  Name: $git_name"
        echo "  Email: $git_email"
        echo ""
        echo -e "${YELLOW}⚠️  This will write your personal information to configuration files.${NC}"
        echo -e "${RED}Only do this if you're comfortable with this info being in your repository.${NC}"
        echo ""
        read -p "Use this Git configuration in your dotfiles? (y/n) [n]: " USE_GIT_CONFIG
        USE_GIT_CONFIG=${USE_GIT_CONFIG:-n}
        
        if [[ "$USE_GIT_CONFIG" =~ ^[Yy]$ ]]; then
            # Update the configuration
            if sed -i '' "s/Your Name/$git_name/g" modules/home/default.nix 2>/dev/null; then
                echo -e "${GREEN}✓ Updated Git name${NC}"
                CHANGES_MADE=true
            fi
            
            if sed -i '' "s/your.email@example.com/$git_email/g" modules/home/default.nix 2>/dev/null; then
                echo -e "${GREEN}✓ Updated Git email${NC}"
                CHANGES_MADE=true
            fi
        else
            echo -e "${YELLOW}⏭  Skipped Git configuration (recommended for public repos)${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ No Git configuration detected${NC}"
        echo "You'll need to manually configure Git in modules/home/default.nix"
    fi
    echo ""
}

# Detect and offer to configure hostname
configure_hostname() {
    echo -e "${BLUE}🖥️  Hostname Configuration${NC}"
    echo "=========================="
    echo ""
    
    local current_hostname
    current_hostname=$(hostname -s)
    
    echo -e "${GREEN}✓ Detected hostname: $current_hostname${NC}"
    echo ""
    echo "This will replace 'workstation' in your configuration files."
    echo -e "${YELLOW}⚠️  This may reveal your computer's name.${NC}"
    echo ""
    read -p "Use '$current_hostname' as your configuration name? (y/n) [n]: " USE_HOSTNAME
    USE_HOSTNAME=${USE_HOSTNAME:-n}
    
    if [[ "$USE_HOSTNAME" =~ ^[Yy]$ ]]; then
        # Update hostname in multiple files
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
            if [ -f "$file" ] && sed -i '' "s/workstation/$current_hostname/g" "$file" 2>/dev/null; then
                echo -e "${GREEN}✓ Updated hostname in $file${NC}"
                CHANGES_MADE=true
            fi
        done
    else
        echo -e "${YELLOW}⏭  Skipped hostname configuration${NC}"
        echo "You can manually change 'workstation' to your preferred name in flake.nix"
    fi
    echo ""
}

# Detect and offer to configure username
configure_username() {
    echo -e "${BLUE}👤 Username Configuration${NC}"
    echo "========================="
    echo ""
    
    local current_user
    current_user=$(whoami)
    
    echo -e "${GREEN}✓ Detected username: $current_user${NC}"
    echo ""
    echo "This will replace 'a' in your Home Manager configuration."
    echo -e "${YELLOW}⚠️  This may reveal your system username.${NC}"
    echo ""
    read -p "Use '$current_user' as your Home Manager username? (y/n) [n]: " USE_USERNAME
    USE_USERNAME=${USE_USERNAME:-n}
    
    if [[ "$USE_USERNAME" =~ ^[Yy]$ ]]; then
        # Update username in configuration files
        if sed -i '' "s/home-manager.users.a/home-manager.users.$current_user/g" flake.nix 2>/dev/null; then
            echo -e "${GREEN}✓ Updated username in flake.nix${NC}"
            CHANGES_MADE=true
        fi
        
        if sed -i '' "s/users.a/users.$current_user/g" modules/home/default.nix 2>/dev/null; then
            echo -e "${GREEN}✓ Updated username in home configuration${NC}"
            CHANGES_MADE=true
        fi
    else
        echo -e "${YELLOW}⏭  Skipped username configuration${NC}"
        echo "You can manually change 'a' to your username in flake.nix"
    fi
    echo ""
}

# Offer to enable modern tools
configure_modern_tools() {
    echo -e "${BLUE}🔧 Modern Tool Replacements${NC}"
    echo "==========================="
    echo ""
    echo "Enable modern tool replacements? This will set up aliases like:"
    echo "  ls → eza (with icons)"
    echo "  cat → bat (with syntax highlighting)"
    echo "  grep → ripgrep (faster searching)"
    echo "  find → fd (simpler syntax)"
    echo ""
    echo "You can always change this later in modules/home/default.nix"
    echo ""
    read -p "Enable modern tool replacements? (y/n) [n]: " ENABLE_MODERN
    ENABLE_MODERN=${ENABLE_MODERN:-n}
    
    if [[ "$ENABLE_MODERN" =~ ^[Yy]$ ]]; then
        if sed -i '' 's/programs.modernTools.enable = false;/programs.modernTools.enable = true;/g' modules/home/default.nix 2>/dev/null; then
            echo -e "${GREEN}✓ Enabled modern tool replacements${NC}"
            CHANGES_MADE=true
        fi
    else
        echo -e "${YELLOW}⏭  Keeping traditional commands${NC}"
        echo "Modern tools will be available with their original names (eza, bat, etc.)"
    fi
    echo ""
}

# Show system information (safe, no personal data)
show_system_info() {
    echo -e "${BLUE}💻 System Information${NC}"
    echo "===================="
    echo ""
    
    local macos_version macos_name chip
    macos_version=$(sw_vers -productVersion)
    macos_name=$(sw_vers -productName)
    chip=$(uname -m)
    
    echo -e "${GREEN}✓ System detected:${NC}"
    echo "  OS: $macos_name $macos_version"
    echo "  Architecture: $chip"
    
    # Check for development tools
    echo ""
    echo -e "${BLUE}Development tools:${NC}"
    
    check_tool() {
        if command -v "$1" &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} $2"
        else
            echo -e "  ${YELLOW}✗${NC} $2"
        fi
    }
    
    check_tool "nix" "Nix package manager"
    check_tool "git" "Git"
    check_tool "brew" "Homebrew"
    check_tool "docker" "Docker"
    check_tool "code" "VS Code"
    
    echo ""
}

# Offer to set up Git security hooks
setup_security_hooks() {
    echo -e "${BLUE}🔒 Git Security Hooks${NC}"
    echo "===================="
    echo ""
    echo "Set up Git hooks to prevent accidentally pushing sensitive information?"
    echo ""
    echo "Features:"
    echo "• Scans for email addresses, SSH keys, API tokens"
    echo "• Blocks pushes to public repos if sensitive data detected"
    echo "• Fully customizable and can be disabled anytime"
    echo ""
    read -p "Set up Git security hooks? (y/n) [y]: " SETUP_HOOKS
    SETUP_HOOKS=${SETUP_HOOKS:-y}
    
    if [[ "$SETUP_HOOKS" =~ ^[Yy]$ ]]; then
        if [ -f "./setup-git-hooks.sh" ]; then
            echo ""
            echo -e "${GREEN}Running Git hooks setup...${NC}"
            chmod +x ./setup-git-hooks.sh
            ./setup-git-hooks.sh
        else
            echo -e "${YELLOW}⚠ setup-git-hooks.sh not found${NC}"
        fi
    else
        echo -e "${YELLOW}⏭  Skipped Git security hooks setup${NC}"
        echo "You can set them up later with: ./setup-git-hooks.sh"
    fi
    echo ""
}

# Create a summary of changes
create_summary() {
    echo -e "${BLUE}📋 Configuration Summary${NC}"
    echo "========================"
    echo ""
    
    if [ "$CHANGES_MADE" = true ]; then
        echo -e "${YELLOW}⚠️  Changes were made to your configuration files.${NC}"
        echo ""
        echo "Files that may have been modified:"
        echo "• modules/home/default.nix"
        echo "• flake.nix"
        echo "• Various documentation files"
        echo ""
        echo -e "${BLUE}Before committing, please review your changes:${NC}"
        echo "  git diff"
        echo ""
        echo -e "${RED}🚨 SECURITY REMINDER:${NC}"
        echo "Review all changes before pushing to a public repository!"
    else
        echo -e "${GREEN}✓ No automatic changes were made to configuration files.${NC}"
        echo ""
        echo "You'll need to manually update:"
        echo "• modules/home/default.nix (Git name and email)"
        echo "• flake.nix (hostname and username)"
    fi
    
    # Create a safe summary file
    cat > .config-wizard-summary.txt << EOF
Configuration Wizard Summary
===========================
Generated: $(date)

System Information:
- OS: $(sw_vers -productName) $(sw_vers -productVersion)
- Architecture: $(uname -m)
- Changes made: $CHANGES_MADE

Next Steps:
1. Review any changes with: git diff
2. Update remaining configuration manually if needed
3. Run: ./bootstrap-mac.sh
4. Verify with: ./smoke-test.sh

Security Note:
This wizard asked for permission before making changes.
Always review changes before committing to public repositories.
EOF
    
    echo ""
    echo -e "${GREEN}✓ Summary saved to .config-wizard-summary.txt${NC}"
}

# Main execution
main() {
    # Check if this looks like a public repository and warn
    IS_PUBLIC_REPO=false
    if check_and_warn_public_repo; then
        IS_PUBLIC_REPO=true
    fi
    
    echo -e "${GREEN}🎯 Starting interactive configuration...${NC}"
    echo ""
    
    # Show system information first (always safe)
    show_system_info
    
    # Configuration steps (user can skip any)
    configure_git_info
    configure_hostname
    configure_username
    configure_modern_tools
    
    # Security features
    setup_security_hooks
    
    # Create summary
    create_summary
    
    echo ""
    echo -e "${GREEN}🎉 Configuration wizard complete!${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    if [ "$CHANGES_MADE" = true ]; then
        echo "1. Review changes: git diff"
        echo "2. Run: ./bootstrap-mac.sh"
    else
        echo "1. Manually update configuration files (see CUSTOMIZE_CHECKLIST.md)"
        echo "2. Run: ./bootstrap-mac.sh"
    fi
    echo "3. Verify installation: ./smoke-test.sh"
    
    if [ "$IS_PUBLIC_REPO" = true ]; then
        echo ""
        echo -e "${RED}🔒 Final Security Reminder:${NC}"
        echo "You indicated this might be a public repository."
        echo "Please double-check that no sensitive information was added!"
    fi
}

# Run main function
main "$@" 