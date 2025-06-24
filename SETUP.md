# 🚀 Quick Setup Guide

Welcome! This guide will help you set up your new Mac with this Nix-Darwin configuration.

## Prerequisites

- macOS 13.0 or later
- Administrative access
- Internet connection
- ~20GB free disk space

## Step-by-Step Setup

### 1. Fork/Clone This Repository

#### Option A: Using as a Template (Recommended)
1. Click "Use this template" button on GitHub
2. Name your repository (e.g., `my-dotfiles`)
3. Clone your new repository:
   ```bash
   git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
   cd YOUR-REPO-NAME
   ```

#### Option B: Direct Fork
1. Fork this repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR-USERNAME/nix-darwin-dotfiles.git
   cd nix-darwin-dotfiles
   ```

### 2. 🔒 Required: Configuration (Security First)

**⚠️ IMPORTANT**: For security, you must configure personal details before proceeding.

#### Option A: Environment File (Recommended)

This keeps sensitive information out of your repository:

1. **Copy the template**:
   ```bash
   cp .env.example .env
   ```

2. **Edit the .env file** with your personal information:
   ```bash
   nano .env
   ```

3. **Apply the configuration**:
   ```bash
   ./load-env-config.sh
   ```

The .env file is automatically ignored by Git, so your sensitive information stays private.

#### Option B: Manual Configuration

1. **Update Git configuration** in `modules/home/default.nix`:
   ```nix
   programs.git = {
     userName = "Your Name";           # <- CHANGE THIS
     userEmail = "your@email.com";     # <- CHANGE THIS
   };
   ```

2. **Update system identifiers** in `flake.nix`:
   ```nix
   darwinConfigurations."testhost" = ...  # <- Change "testhost"
   home-manager.users.a = ...                # <- Change "a" to your username
   ```

3. **Review installed apps** in `modules/homebrew/apps.nix` and comment out any you don't want

### 3. System Detection (Optional)

Run the safe system detection script to check your setup:

```bash
./auto-configure.sh
```

This script will:
- ✅ Detect your system specifications (macOS version, architecture)
- ✅ Check for installed development tools
- ✅ Identify configuration files that still need updates
- ✅ Create a system summary file
- ❌ **Will NOT** automatically write sensitive information

**What it does NOT do (for security):**
- ❌ Write Git credentials to files
- ❌ Detect or write SSH/GPG keys
- ❌ Write email addresses or personal information
- ❌ Make automatic changes to configuration files

### 4. Run the Bootstrap

```bash
# Make scripts executable
chmod +x bootstrap-mac.sh

# Run the bootstrap
./bootstrap-mac.sh
```

This will:
- Install Nix package manager
- Apply the configuration
- Install all specified packages

**Note**: First run takes 15-30 minutes depending on internet speed.

### 4. Verify Installation

```bash
# Run smoke tests
./smoke-test.sh

# Check configuration mode
./test-modern-tools.sh
```

### 5. Post-Installation

1. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

2. **Optional: Enable modern tool replacements**:
   Edit `modules/home/default.nix`:
   ```nix
   programs.modernTools.enable = true;  # Default is false
   ```
   Then rebuild:
   ```bash
   darwin-rebuild switch --flake ".#testhost"
   ```

3. **Set up Git signing** (optional):
   ```bash
   # Generate GPG key
   gpg --full-generate-key
   
   # Add to Git config
   git config --global user.signingkey YOUR-KEY-ID
   ```

## 🎯 Customization Tips

### Adding Your Own Tools

1. **CLI tools**: Add to `modules/system/cli-utils.nix`
2. **GUI apps**: Add to `modules/homebrew/apps.nix`
3. **Development tools**: Add to `modules/system/core.nix`

### Creating Custom Modules

Create a new file in `modules/`:
```nix
{ pkgs, ... }:
{
  # Your custom configuration
}
```

Then import it in `flake.nix`.

### Useful Commands

```bash
# Update all packages
nix flake update
darwin-rebuild switch --flake ".#testhost"

# Rollback if something breaks
darwin-rebuild rollback

# Search for packages
nix search nixpkgs package-name

# Clean old generations
nix-collect-garbage -d
```

## 🆘 Troubleshooting

### Common Issues

**"command not found: darwin-rebuild"**
- Restart your terminal or run: `source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`

**"error: flake ... does not exist"**
- Make sure you're in the repository directory
- Check that all files are committed: `git add . && git commit -m "Initial setup"`

**"Homebrew installation failed"**
- Homebrew requires Xcode Command Line Tools
- Run: `xcode-select --install`

### Getting Help

1. Check existing [issues](https://github.com/YOUR-USERNAME/YOUR-REPO/issues)
2. Review the [documentation](./README.md)
3. Open a new issue with:
   - Your macOS version
   - Error messages
   - Output of `./smoke-test.sh`

## 🎉 Next Steps

- Explore the [CLI Cheatsheet](./CLI_CHEATSHEET.md)
- Review [Configuration Options](./CONFIG_OPTIONS.md)
- Star the repository if you find it useful!
- Share your customizations via PR

Happy coding! 🚀 