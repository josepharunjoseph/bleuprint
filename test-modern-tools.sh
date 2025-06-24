#!/usr/bin/env bash
# Test script to show the difference between modernTools enabled/disabled

echo "🧪 Modern Tools Configuration Test"
echo ""

# Check if modernTools is enabled
if alias ls 2>/dev/null | grep -q "eza"; then
    echo "✅ modernTools.enable = true"
    echo ""
    echo "Traditional commands are replaced:"
    echo "  ls → $(alias ls 2>/dev/null | cut -d'=' -f2-)"
    echo "  cat → $(alias cat 2>/dev/null | cut -d'=' -f2-)"
    echo "  grep → $(alias grep 2>/dev/null | cut -d'=' -f2-)"
    echo "  find → $(alias find 2>/dev/null | cut -d'=' -f2-)"
    echo ""
    echo "Alternative tools available as:"
    echo "  ls2 → lsd"
    echo "  tree2 → broot"
    echo "  tmux2 → zellij"
else
    echo "❌ modernTools.enable = false (default)"
    echo ""
    echo "Traditional commands work normally."
    echo "Modern tools available with their original names:"
    echo "  eza, bat, ripgrep, fd, btop, etc."
    echo ""
    echo "Or via shortcuts:"
    echo "  e → eza"
    echo "  b → bat"
    echo "  f → fd"
fi

echo ""
echo "💡 To toggle this setting, edit modules/home/default.nix"
echo "   and change: programs.modernTools.enable"
echo ""
echo "Available modern tools:"
echo ""

# Test what's installed
tools=(
    "eza:Modern ls"
    "bat:Better cat"
    "ripgrep:Fast grep"
    "fd:Fast find"
    "btop:System monitor"
    "duf:Modern df"
    "dust:Modern du"
    "procs:Modern ps"
    "dog:Modern dig"
    "gping:Graphical ping"
    "delta:Better diffs"
    "lsd:Alternative ls"
    "erd:Modern tree"
    "broot:Interactive tree"
    "zellij:tmux alternative"
    "helix:Modern editor"
)

for tool_spec in "${tools[@]}"; do
    cmd="${tool_spec%%:*}"
    desc="${tool_spec##*:}"
    if command -v "$cmd" > /dev/null 2>&1; then
        printf "  ✓ %-12s %s\n" "$cmd" "($desc)"
    fi
done 