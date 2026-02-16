#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGE_DIR="$SCRIPT_DIR/package"

if [ ! -d "$PACKAGE_DIR" ]; then
    echo "Error: package/ directory not found at $PACKAGE_DIR"
    exit 1
fi

# Try to update first; if that fails (not installed yet), do a fresh install
if kpackagetool6 -t Plasma/Applet -u "$PACKAGE_DIR" 2>/dev/null; then
    echo "Widget updated successfully."
else
    kpackagetool6 -t Plasma/Applet -i "$PACKAGE_DIR"
    echo "Widget installed successfully."
fi

echo ""
echo "To use: Right-click your panel → 'Add Widgets' → search 'Claude Code Usage'"
echo "To uninstall: kpackagetool6 -t Plasma/Applet -r com.github.claude-code-usage"
