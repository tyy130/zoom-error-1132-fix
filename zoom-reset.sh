#!/bin/bash
# Zoom Reset - Fixes Error 1132 and other Zoom issues
# Just run: ./zoom-reset.sh

# Window state: "keep" = wait for Enter, "close" = exit immediately
WINDOW_STATE="keep"

cleanup() {
    if [ "$WINDOW_STATE" = "keep" ]; then
        echo ""
        echo "Press Enter to close..."
        read -r
    fi
}
trap cleanup EXIT

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
    pwsh "$MAIN_SCRIPT" "$@"
    if [ $? -eq 0 ]; then
        # SUCCESS: Zoom launched, close terminal automatically
        WINDOW_STATE="close"
    fi
    # FAILURE: keep terminal open (trap will prompt)
    exit 0
fi

# PowerShell not found - keep terminal open for install instructions
echo "PowerShell is required but not installed."
echo ""

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "To install on macOS, run:"
    echo "  brew install powershell/tap/powershell"
    echo ""
    if command -v brew &> /dev/null; then
        echo -n "Install now? (y/N): "
        read -r REPLY
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            brew install powershell/tap/powershell
            if command -v pwsh &> /dev/null; then
                echo ""
                echo "Installed! Running Zoom Reset..."
                pwsh "$MAIN_SCRIPT" "$@"
                if [ $? -eq 0 ]; then WINDOW_STATE="close"; fi
            fi
        fi
    else
        echo "Homebrew not found. Install Homebrew first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    fi
else
    # Linux
    echo "To install on Linux:"
    echo ""
    echo "  Ubuntu/Debian/Mint:"
    echo "    sudo snap install powershell --classic"
    echo ""
    echo "  Or manual install:"
    echo "    sudo apt-get update"
    echo "    sudo apt-get install -y wget"
    echo "    wget -q https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell_7.4.6-1.deb_amd64.deb"
    echo "    sudo dpkg -i powershell_7.4.6-1.deb_amd64.deb"
    echo "    sudo apt-get install -f"
    echo ""
    
    # Check for snap first (most reliable on Ubuntu/Mint)
    if command -v snap &> /dev/null; then
        echo -n "Install via snap? (y/N): "
        read -r REPLY
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            sudo snap install powershell --classic
            if command -v pwsh &> /dev/null; then
                echo ""
                echo "Installed! Running Zoom Reset..."
                pwsh "$MAIN_SCRIPT" "$@"
                if [ $? -eq 0 ]; then WINDOW_STATE="close"; fi
            fi
        fi
    else
        echo -n "Install via .deb package? (y/N): "
        read -r REPLY
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            wget -q https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell_7.4.6-1.deb_amd64.deb -O /tmp/powershell.deb
            sudo dpkg -i /tmp/powershell.deb
            sudo apt-get install -f -y
            rm /tmp/powershell.deb
            if command -v pwsh &> /dev/null; then
                echo ""
                echo "Installed! Running Zoom Reset..."
                pwsh "$MAIN_SCRIPT" "$@"
                if [ $? -eq 0 ]; then WINDOW_STATE="close"; fi
            fi
        fi
    fi
fi

# EXIT trap handles "Press Enter to close..." when WINDOW_STATE="keep"
