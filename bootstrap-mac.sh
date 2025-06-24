#!/usr/bin/env bash
set -e

echo "🚀 Starting Mac bootstrap..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if system detection has been run
if [ ! -f ".system-info.txt" ]; then
    echo -e "${BLUE}🤖 System Detection${NC}"
    echo "Would you like to run system detection to check your setup?"
    echo "This will help identify what needs to be configured (no sensitive data written)."
    read -p "Run system detection? (y/n) [y]: " RUN_DETECTION
    RUN_DETECTION=${RUN_DETECTION:-y}
    
    if [[ "$RUN_DETECTION" =~ ^[Yy]$ ]]; then
        if [ -x "./auto-configure.sh" ]; then
            ./auto-configure.sh
            echo ""
        else
            echo -e "${YELLOW}⚠️  auto-configure.sh not found or not executable${NC}"
            echo "Run: chmod +x auto-configure.sh"
        fi
    fi
else
    echo -e "${GREEN}✓ System detection already completed${NC}"
    echo "System info available in .system-info.txt"
    echo ""
fi

# Check for required manual configuration
echo -e "${BLUE}📝 Configuration Check${NC}"
NEEDS_CONFIG=false

if grep -q "Your Name" modules/home/default.nix 2>/dev/null; then
    echo -e "${YELLOW}⚠ Git name needs to be set in modules/home/default.nix${NC}"
    NEEDS_CONFIG=true
fi

if grep -q "your.email@example.com" modules/home/default.nix 2>/dev/null; then
    echo -e "${YELLOW}⚠ Git email needs to be set in modules/home/default.nix${NC}"
    NEEDS_CONFIG=true
fi

if grep -q "testhost" flake.nix 2>/dev/null; then
    echo -e "${YELLOW}⚠ Hostname 'testhost' should be customized in flake.nix${NC}"
    NEEDS_CONFIG=true
fi

if grep -q "home-manager.users.a" flake.nix 2>/dev/null; then
    echo -e "${YELLOW}⚠ Username 'a' should be customized in flake.nix${NC}"
    NEEDS_CONFIG=true
fi

if [ "$NEEDS_CONFIG" = true ]; then
    echo ""
    echo -e "${RED}🔒 Security Notice:${NC}"
    echo "Configuration files contain placeholder values that should be customized."
    echo ""
    echo "Required updates:"
    echo "1. Edit modules/home/default.nix:"
    echo "   - Change 'Your Name' to your actual name"
    echo "   - Change 'your.email@example.com' to your email"
    echo "2. Edit flake.nix:"
    echo "   - Change 'testhost' to your preferred hostname"
    echo "   - Change 'home-manager.users.a' to your username"
    echo ""
    echo "See CUSTOMIZE_CHECKLIST.md for detailed instructions."
    echo ""
    read -p "Continue with placeholder values? (NOT recommended) (y/n) [n]: " CONTINUE_ANYWAY
    CONTINUE_ANYWAY=${CONTINUE_ANYWAY:-n}
    
    if [[ ! "$CONTINUE_ANYWAY" =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${YELLOW}Installation cancelled for security.${NC}"
        echo "Please customize your configuration files first."
        echo ""
        echo "Quick start:"
        echo "1. cp modules/home/default.nix modules/home/default.nix.bak"
        echo "2. Edit modules/home/default.nix with your details"
        echo "3. Edit flake.nix with your hostname and username"
        echo "4. Run this script again"
        exit 0
    else
        echo ""
        echo -e "${RED}⚠️ Proceeding with placeholder values (not recommended for production)${NC}"
    fi
else
    echo -e "${GREEN}✓ Configuration appears to be properly customized${NC}"
fi

# Install Nix if not present
echo ""
echo -e "${BLUE}📦 Checking Nix installation...${NC}"
if ! command -v nix &> /dev/null; then
    echo "Installing Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    echo "Nix installed. You may need to restart your terminal."
    echo ""
    echo "After restarting, run this script again to continue."
    exit 0
else
    echo -e "${GREEN}✓ Nix already installed${NC}"
fi

# Detect the configuration name
CONFIG_NAME=$(grep -o 'darwinConfigurations\."[^"]*"' flake.nix | cut -d'"' -f2 | head -1)
CONFIG_NAME=${CONFIG_NAME:-testhost}

echo ""
echo -e "${BLUE}🔧 Applying Nix-Darwin configuration...${NC}"
echo "Configuration name: $CONFIG_NAME"

# Apply the configuration
nix run nix-darwin -- switch --flake ".#$CONFIG_NAME"

echo ""
echo -e "${GREEN}✨ Bootstrap complete!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Run ./smoke-test.sh to verify installation"
echo "3. Check ./test-modern-tools.sh to see your tool configuration"
echo "4. Optional: Run ./setup-git-hooks.sh for security hooks"
echo "5. Review CUSTOMIZE_CHECKLIST.md for additional customization options"
echo ""
echo -e "${YELLOW}Security reminder:${NC}"
echo "If you used placeholder values, update them in your configuration files." 