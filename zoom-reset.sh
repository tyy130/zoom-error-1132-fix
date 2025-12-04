#!/bin/bash
# Zoom Reset - Fixes Error 1132 and other Zoom issues
# Just run: ./zoom-reset.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MAIN_SCRIPT="$SCRIPT_DIR/zoom-reset-and-reinstall.ps1"

echo ""
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║       Zoom Reset & Reinstall Tool         ║"
echo "  ║     Fixes Error 1132 and other issues     ║"
echo "  ╚═══════════════════════════════════════════╝"
echo ""

# Check if pwsh is available
if command -v pwsh &> /dev/null; then
    exec pwsh "$MAIN_SCRIPT" "$@"
fi

# PowerShell not found - try to install it
echo "Installing required component (PowerShell)..."
echo ""

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v brew &> /dev/null; then
        echo "Installing via Homebrew..."
        brew install powershell/tap/powershell
    else
        echo "Please install Homebrew first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        echo ""
        echo "Then run this script again."
        exit 1
    fi
else
    # Linux
    echo "Installing via Microsoft's installer..."
    curl -sSL https://aka.ms/install-powershell.sh | sudo bash
fi

# Check if installation worked
if command -v pwsh &> /dev/null; then
    echo ""
    echo "Installation complete! Running Zoom Reset..."
    echo ""
    exec pwsh "$MAIN_SCRIPT" "$@"
else
    echo ""
    echo "Automatic installation failed."
    echo "Please visit: https://aka.ms/powershell"
    echo "Then run this script again."
    exit 1
fi
