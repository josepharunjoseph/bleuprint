#!/usr/bin/env bash
# Setup script for optional Git security hooks

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

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