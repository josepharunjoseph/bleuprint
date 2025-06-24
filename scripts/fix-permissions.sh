#!/usr/bin/env bash
# Fix execute permissions on all shell scripts

echo "🔧 Fixing permissions on shell scripts..."

# Make all .sh files executable
for script in *.sh; do
    if [ -f "$script" ]; then
        chmod +x "$script"
        echo "  ✓ $script"
    fi
done

echo "✅ Done!" 