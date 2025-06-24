# 📋 Template Information

This repository is designed to be used as a GitHub template. Here's what you get:

## What's Included

### 🛠️ Pre-configured Tools (120+)

**Development Languages:**
- Go 1.24, Rust (via rustup), Python 3.13, Node.js 22 LTS

**Modern CLI Tools:**
- File management: `eza`, `bat`, `fd`, `ripgrep`, `erd`
- System monitoring: `btop`, `duf`, `dust`, `procs`
- Development: `lazygit`, `gh`, `delta`, `httpie`
- Security: `age`, `sops`, `gpg`
- And 100+ more...

**GUI Applications:**
- Raycast, VS Code, OrbStack, Kitty
- Obsidian, Slack, GitHub Desktop
- Stats, Rectangle, iTerm2/WezTerm

### 📁 Template Files

- **Issue Templates**: Bug reports and feature requests
- **PR Template**: Standardized pull request format
- **Community Files**: CODE_OF_CONDUCT.md, CONTRIBUTING.md, SECURITY.md
- **GitHub Actions**: CI checks and template cleanup
- **Documentation**: Setup guide, cheatsheet, configuration options

### ⚙️ Configuration Features

- **Modular design**: Easy to add/remove components
- **Optional modern aliases**: Replace traditional commands with modern alternatives
- **ML/Data Science stack**: PyTorch, TensorFlow, Jupyter (optional module)
- **Security hardening**: Touch ID sudo, commit signing ready

## Using This Template

### Method 1: GitHub UI (Recommended)
1. Click "Use this template" button
2. Name your new repository
3. Clone and follow SETUP.md

### Method 2: GitHub CLI
```bash
gh repo create my-dotfiles --template YOUR-USERNAME/nix-darwin-template
cd my-dotfiles
```

### Method 3: Manual Fork
1. Fork this repository
2. Clone your fork
3. Remove template-specific files manually

## What Happens After You Use This Template

1. **Automatic cleanup**: A GitHub Action will run to:
   - Replace placeholder URLs with your repository info
   - Update contact emails
   - Remove template-specific files

2. **You'll need to**:
   - Update Git user info in `modules/home/default.nix`
   - Review and customize installed packages
   - Run `./bootstrap-mac.sh`

## Customization Points

### Essential Changes
- Git username/email
- Repository name in flake.nix (if desired)
- Security contact email

### Optional Changes
- Enable/disable modern tool aliases
- Add/remove GUI applications
- Enable ML/data science stack
- Customize shell aliases
- Add your own modules

## Support

- **Issues**: Use issue templates for bugs/features
- **Discussions**: For questions and sharing customizations
- **Wiki**: Add your own documentation as needed

## Why Use This Template?

✅ **Save 2-3 days** of initial setup time
✅ **Best practices** built-in from the start
✅ **Battle-tested** configuration
✅ **Active maintenance** and updates
✅ **Community-driven** improvements

---

Ready to supercharge your Mac setup? Click "Use this template" and get started! 🚀 