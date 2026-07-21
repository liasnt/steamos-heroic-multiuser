#!/bin/bash
# ==============================================================================
# Title:        SteamOS Heroic Launcher - Multi-User Installer
# Description:  Automated setup script that downloads and installs the main
#               script for the Heroic Multi-User & Prefix Isolator on SteamOS.
# Author:       The SteamOS Tinkerer (Reddit: u/CiberOne)
# Version:      1.0
# Date:         2026-07-16
# ==============================================================================

set -e

INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="heroic-multiuser.sh"
REPO_RAW_URL="https://raw.githubusercontent.com/liasnt/steamos-heroic-multiuser/refs/heads/main/heroic-multiuser.sh"

echo "===================================================="
echo " Heroic Multi-User & Prefix Isolator Installation"
echo "===================================================="

# Ensure ~/.local/bin exists
mkdir -p "$INSTALL_DIR"

echo "[1/3] Downloading script..."
if command -v curl >/dev/null 2>&1; then
    curl -sSL "$REPO_RAW_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "$INSTALL_DIR/$SCRIPT_NAME" "$REPO_RAW_URL"
else
    echo "ERROR: Neither curl nor wget is installed."
    exit 1
fi

echo "[2/3] Setting execution permissions..."
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo "[3/3] Checking environment..."
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Notice: $HOME/.local/bin is not in your PATH."
    echo "You can launch the script using: $INSTALL_DIR/$SCRIPT_NAME"
fi

echo ""
echo "===================================================="
echo " Installation Complete!"
echo "===================================================="
echo "Location: $INSTALL_DIR/$SCRIPT_NAME"
echo ""
echo "Next steps:"
echo "1. Open Steam in Desktop Mode."
echo "2. Add a Non-Steam Game pointing to:"
echo "   $INSTALL_DIR/$SCRIPT_NAME"
echo "3. Rename it to 'Heroic Games Launcher' in Steam."
echo "===================================================="
