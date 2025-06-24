# Contributing to Nix-Darwin Dotfiles Template

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing.

## 🤝 Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct (see CODE_OF_CONDUCT.md).

## 📋 How to Contribute

### Reporting Issues

1. Check existing issues to avoid duplicates
2. Use the issue templates provided
3. Include as much detail as possible:
   - System information (macOS version, hardware)
   - Steps to reproduce
   - Expected vs actual behavior
   - Error messages/logs

### Suggesting Features

1. Check if the feature has already been suggested
2. Use the feature request template
3. Explain the use case and benefits
4. Consider if it benefits most users or should be optional

### Submitting Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Test your changes** thoroughly:
   ```bash
   darwin-rebuild switch --flake ".#testhost"
   ./smoke-test.sh
   ```
3. **Update documentation** if needed
4. **Follow the style**:
   - Use meaningful commit messages
   - Keep changes focused and atomic
   - Comment complex configurations
5. **Submit the PR** using the template

## 🧪 Testing

Before submitting:

1. Ensure all existing tests pass
2. Test on a clean macOS installation if possible
3. Verify no regressions in basic functionality
4. Check that optional features remain optional

## 📁 Project Structure

Understanding the structure helps you contribute effectively:

```
modules/
├── system/          # System-level packages and settings
├── homebrew/        # GUI apps and Mac-specific tools
└── home/           # User configurations
```

## 💡 Guidelines for New Tools

When adding new tools:

1. **Prefer Nix packages** over Homebrew when available
2. **Include documentation links** as comments
3. **Consider performance** - avoid heavy/slow tools
4. **Make it optional** if it's not universally needed
5. **Test the installation** from scratch

## 🎨 Style Guide

### Nix Files
- Use 2-space indentation
- Add comments for non-obvious configurations
- Group related settings together
- Include URLs for documentation

### Shell Scripts
- Use bash with `set -e`
- Add error handling
- Include progress messages
- Make scripts idempotent

### Documentation
- Keep README concise but complete
- Update CONFIG_OPTIONS.md for new options
- Add examples to CLI_CHEATSHEET.md
- Use clear, descriptive headers

## 🔄 Pull Request Process

1. Update relevant documentation
2. Add yourself to CONTRIBUTORS.md (if it exists)
3. Ensure CI passes (if configured)
4. Request review from maintainers
5. Address feedback promptly
6. Squash commits if requested

## ❓ Questions?

- Open a discussion for general questions
- Join community chat (if available)
- Tag maintainers for urgent issues

Thank you for contributing! 🎉 