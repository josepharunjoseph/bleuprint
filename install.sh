#!/usr/bin/env bash
set -euo pipefail

# Bleuprint Quick Install
# One-liner setup for the laziest developers
# Uses sensible defaults, no customization required

echo "🚀 Bleuprint Quick Install"
echo "=========================="
echo ""
echo "Setting up your Mac with 120+ developer tools..."
echo "Using sensible defaults - no configuration required!"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check macOS version
MACOS_VERSION=$(sw_vers -productVersion)
MACOS_MAJOR=$(echo "$MACOS_VERSION" | cut -d. -f1)

echo "Detected macOS: $MACOS_VERSION"

if [ "$MACOS_MAJOR" -lt 13 ]; then
    echo "❌ macOS 13 (Ventura) or later required"
    echo "Current version: $MACOS_VERSION"
    echo "Please upgrade macOS before continuing"
    exit 1
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo -e "${BLUE}📥 Downloading bleuprint template...${NC}"

# Download the repository
curl -fsSL https://github.com/bleulabs/bleuprint/archive/master.tar.gz | tar -xz
cd bleuprint-master

echo -e "${BLUE}⚙️ Setting up with defaults...${NC}"

# Create sensible default configuration
cat > .env << 'EOF'
# Quick Install Configuration - Sensible Defaults
GIT_USER_NAME="Developer"
GIT_USER_EMAIL="dev@example.local"
HOSTNAME="macbook"
USERNAME="$(whoami)"
ENABLE_MODERN_TOOLS="true"
ENABLE_GPG_SIGNING="false"
EOF

echo -e "${BLUE}🔧 Applying configuration...${NC}"

# Apply the configuration
./scripts/load-env-config.sh

echo -e "${BLUE}📦 Installing Nix (if needed)...${NC}"

# Install Nix if not present
if ! command -v nix &> /dev/null; then
    echo "Installing Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    echo "Nix installed. Please restart your terminal and run this script again."
    exit 0
fi

echo -e "${BLUE}🚀 Bootstrapping your Mac...${NC}"

# Run the bootstrap
./scripts/bootstrap-mac.sh

echo ""
echo -e "${GREEN}✨ Quick install complete!${NC}"
echo ""
echo -e "${BLUE}What was installed:${NC}"
echo "• 120+ modern CLI tools (eza, bat, ripgrep, fzf, etc.)"
echo "• Development languages (Go, Rust, Python, Node.js)"
echo "• GUI applications via Homebrew"
echo "• Modern shell configuration with Zsh"
echo "• Security tools and Git hooks"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Restart your terminal: source ~/.zshrc"
echo "2. Try some new tools: eza, bat, rg, fzf"
echo "3. Run 'tldr <command>' for quick help"
echo ""
echo -e "${BLUE}To customize further:${NC}"
echo "1. Fork the template: https://github.com/new?template_name=bleuprint&template_owner=bleulabs"
echo "2. Edit the Nix configuration files"
echo "3. Re-run: darwin-rebuild switch --flake \".#$HOSTNAME\""
echo ""
echo -e "${GREEN}🎉 Happy coding with your new setup!${NC}"

# Cleanup
cd /
rm -rf "$TEMP_DIR" 