# ✅ Customization Checklist

After creating your repository from this template, follow this checklist to personalize your setup:

## 🔒 Security First

> **⚠️ IMPORTANT**: This template is designed to be safe for public repositories. Never commit sensitive information like:
> - Personal email addresses
> - SSH keys or GPG keys
> - API tokens or passwords
> - Internal hostnames or network information

- [ ] **Review all placeholder values** before committing
- [ ] **Keep sensitive config in private files** (use `.gitignore`)
- [ ] **Use environment variables** for secrets when needed

## 🔴 Required Changes

### Option 1: Environment File (Recommended)
- [ ] **Copy environment template**: `cp .env.example .env`
- [ ] **Edit .env file** with your personal information (automatically ignored by Git)
- [ ] **Apply configuration**: `./load-env-config.sh`

### Option 2: Manual Configuration
- [ ] **Update Git configuration** in `modules/home/default.nix`:
  ```nix
  programs.git = {
    userName = "Your Name";           # Line 74 - CHANGE THIS
    userEmail = "your@email.com";     # Line 75 - CHANGE THIS
  };
  ```

- [ ] **Update hostname** in `flake.nix`:
  ```nix
  darwinConfigurations."workstation" = ...  # Change "workstation"
  ```

- [ ] **Update username** in `flake.nix`:
  ```nix
  home-manager.users.a = ...  # Change "a" to your username
  ```

- [ ] **Update repository URLs** (if not auto-updated):
  - [ ] README.md - repository links at the bottom
  - [ ] SETUP.md - clone URLs
  - [ ] Issue templates - if you add custom links

## 🟡 Recommended Changes

- [ ] **Review installed applications** in `modules/homebrew/apps.nix`:
  - [ ] Comment out apps you don't need
  - [ ] Add your preferred apps

- [ ] **Choose your shell history tool**:
  - [ ] Keep Atuin (default) OR
  - [ ] Switch to McFly in `modules/home/default.nix`

- [ ] **Enable/disable modern tool aliases**:
  ```nix
  programs.modernTools.enable = true;  # or false (default)
  ```

## 🟢 Optional Customizations

- [ ] **Add ML/Data Science tools**:
  - [ ] Uncomment `./modules/system/ml-stack.nix` in `flake.nix`

- [ ] **Customize shell aliases** in `modules/home/default.nix`

- [ ] **Add your own modules**:
  - [ ] Create new `.nix` files in `modules/`
  - [ ] Import them in `flake.nix`

- [ ] **Set up commit signing** (optional):
  - [ ] Generate GPG key locally
  - [ ] Add key ID to Git config in `modules/home/default.nix`
  - [ ] Keep key ID out of public repos

- [ ] **Choose default terminal**:
  - [ ] Keep Kitty OR
  - [ ] Switch to WezTerm/iTerm2

## 📝 Documentation Updates

- [ ] **Update LICENSE**:
  - [ ] Replace `[YOUR NAME]` with your name
  - [ ] Update year if needed

- [ ] **Update security contacts**:
  - [ ] CODE_OF_CONDUCT.md - enforcement email
  - [ ] SECURITY.md - security email

- [ ] **Remove template files** (optional):
  - [ ] TEMPLATE_INFO.md
  - [ ] CUSTOMIZE_CHECKLIST.md (this file)
  - [ ] .github/template-cleanup.yml (if not auto-removed)

## 🚀 Final Steps

- [ ] **Run system detection**: `./auto-configure.sh`
- [ ] **Bootstrap your system**: `./bootstrap-mac.sh`
- [ ] **Verify installation**: `./smoke-test.sh`
- [ ] **Test configuration**: `./test-modern-tools.sh`
- [ ] **Commit your changes** (review diffs first!)
- [ ] **Push to your repository**
- [ ] **Star the original template** if helpful! ⭐

---

💡 **Security Tip**: Run `git diff --cached` before committing to review all changes and ensure no sensitive information is included! 