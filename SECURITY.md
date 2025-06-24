# Security Policy

## 🔒 Security-First Design

This template is designed with security as a top priority, especially for public repositories. We've implemented multiple layers of protection to prevent accidental exposure of sensitive information.

## 🛡️ Security Features

### 1. Environment File Protection
- **`.env` files are automatically ignored** by Git
- **Git hooks scan for and block** any attempts to commit `.env` files
- **Template file (`.env.example`) is safe** and contains no sensitive data
- **Loader script applies configuration** without exposing sensitive data in repository

### 2. Pre-Push Security Hooks
Our Git hooks scan for potentially sensitive patterns before allowing pushes:
- **Email addresses** (Gmail, Yahoo, work domains, etc.)
- **SSH keys** (RSA, Ed25519, OpenSSH private keys)
- **GPG keys** (PGP private/public keys)
- **API tokens** (GitHub, OpenAI, Slack, etc.)
- **Common secrets** (passwords, tokens, keys)
- **Real names** in Git configuration

### 3. Interactive Configuration
- **Explicit consent required** for each configuration step
- **Clear warnings** about what information will be written
- **Public repository detection** with extra security prompts
- **Option to skip** any potentially sensitive configuration

### 4. Safe Defaults
- **No automatic detection** of sensitive information
- **Placeholder values** used by default
- **Manual configuration required** for all personal details
- **Security warnings** throughout the setup process

## 🚨 What We Protect Against

### Critical Security Risks
- ❌ **Personal email addresses** in public repositories
- ❌ **SSH private keys** or key fingerprints
- ❌ **GPG keys** or signing key IDs
- ❌ **API tokens** and access keys
- ❌ **Internal hostnames** or network information
- ❌ **Real names** that users want to keep private

### Common Mistakes
- ❌ Committing `.env` files with sensitive data
- ❌ Auto-configuring without user consent
- ❌ Writing detected system information automatically
- ❌ Exposing work email addresses or internal domains

## 🔧 How to Use Securely

### Recommended Approach: Environment Files
1. **Copy the template**: `cp .env.example .env`
2. **Edit with your information**: `nano .env`
3. **Apply configuration**: `./load-env-config.sh`
4. **Review changes**: `git diff` (before committing)

### Alternative: Interactive Wizard
1. **Run the wizard**: `./auto-configure.sh`
2. **Approve each step** individually
3. **Skip sensitive information** for public repositories
4. **Review all changes** before committing

### Manual Configuration
1. **Edit configuration files** directly
2. **Use placeholder values** for public repositories
3. **Keep sensitive config** in private files
4. **Use environment variables** for secrets

## 🔍 Security Checks

### Automatic Protections
- **Git hooks** scan all files before push
- **Environment files** are blocked from commits
- **Sensitive patterns** trigger warnings
- **Public repository detection** enables extra checks

### Manual Reviews
- **Always run `git diff`** before committing
- **Check for personal information** in all files
- **Verify placeholder values** are still in place
- **Review generated configuration** files

## 🚨 If You Accidentally Commit Sensitive Data

### Immediate Actions
1. **Stop pushing** to the repository
2. **Remove sensitive data** from files
3. **Rewrite Git history** if already pushed:
   ```bash
   git filter-branch --force --index-filter \
   'git rm --cached --ignore-unmatch path/to/sensitive/file' \
   --prune-empty --tag-name-filter cat -- --all
   ```
4. **Force push** the cleaned history (if repository is yours)
5. **Rotate compromised credentials** (keys, tokens, passwords)

### Prevention
- **Enable Git hooks**: `./setup-git-hooks.sh`
- **Use environment files** for sensitive data
- **Review all changes** before committing
- **Keep `.env` files local** and never commit them

## 📞 Reporting Security Issues

If you discover a security vulnerability in this template:

1. **DO NOT** open a public issue
2. **Email security concerns** to: [your-security-email@domain.com]
3. **Include detailed information** about the vulnerability
4. **Wait for acknowledgment** before public disclosure

We take security seriously and will respond promptly to verified security reports.

## 🔄 Security Updates

We regularly update security patterns and protections. To get the latest:

1. **Check for updates** to the template repository
2. **Update Git hook patterns** in `.githooks/pre-push`
3. **Review new security features** in release notes
4. **Test security hooks** with: `git push --dry-run`

## 📚 Security Best Practices

### For Public Repositories
- ✅ Use environment files for all sensitive data
- ✅ Enable Git security hooks
- ✅ Review all changes before committing
- ✅ Use placeholder values in configuration
- ✅ Keep real credentials in private files
- ✅ Regularly audit repository contents

### For Private Repositories
- ✅ Still use environment files for portability
- ✅ Enable security hooks as a safety net
- ✅ Document sensitive configuration clearly
- ✅ Limit repository access appropriately
- ✅ Consider encryption for highly sensitive data

### General Security
- ✅ Rotate credentials regularly
- ✅ Use strong, unique passwords
- ✅ Enable 2FA on all accounts
- ✅ Keep software and dependencies updated
- ✅ Monitor for unauthorized access
- ✅ Follow principle of least privilege

---

**Remember**: Security is a shared responsibility. While this template provides strong protections, always review and understand what you're committing to public repositories. 