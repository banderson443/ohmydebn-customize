#!/bin/bash

# ============================================================
# OhMyDebn Post-Install Customization Script
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Starting OhMyDebn Customization from $SCRIPT_DIR..."

# ------------------------------------------------------------
# 1. Restore Wallpaper
# ------------------------------------------------------------
echo ">>> Setting up Wallpaper..."
BG_IMAGE="wallpaper.png"
DEST_BG_DIR="$HOME/.local/share/backgrounds"

if [ -f "$SCRIPT_DIR/$BG_IMAGE" ]; then
    mkdir -p "$DEST_BG_DIR"
    cp "$SCRIPT_DIR/$BG_IMAGE" "$DEST_BG_DIR/"
    
    # Set for Cinnamon
    gsettings set org.cinnamon.desktop.background picture-uri "file://$DEST_BG_DIR/$BG_IMAGE"
    gsettings set org.cinnamon.desktop.background picture-options "zoom"
    
    echo "[+] Wallpaper set to $BG_IMAGE"
else
    echo "[-] Wallpaper image not found in pack."
fi

# ------------------------------------------------------------
# 2. Restore Conky
# ------------------------------------------------------------
echo ">>> Setting up Conky..."
if [ -d "$SCRIPT_DIR/Conky" ]; then
    # Copy Conky folder to Documents to match original structure
    mkdir -p "$HOME/Documents"
    cp -r "$SCRIPT_DIR/Conky" "$HOME/Documents/"
    
    # Run the installer
    if [ -f "$HOME/Documents/Conky/bootstrap_conky.sh" ]; then
        cd "$HOME/Documents/Conky"
        chmod +x bootstrap_conky.sh
        
        echo "Running Conky installer..."
        ./bootstrap_conky.sh
    else
        echo "[-] Conky installer script not found."
    fi
else
    echo "[-] Conky folder not found in pack."
fi

# ------------------------------------------------------------
# 3. Restore Tools
# ------------------------------------------------------------
echo ">>> Installing Tools..."
if [ -f "$SCRIPT_DIR/debn-pentest-setup.sh" ]; then
    # Copy to Documents
    mkdir -p "$HOME/Documents"
    cp "$SCRIPT_DIR/debn-pentest-setup.sh" "$HOME/Documents/"
    chmod +x "$HOME/Documents/debn-pentest-setup.sh"
    
    echo "Running Tools installer (this may take a while)..."
    "$HOME/Documents/debn-pentest-setup.sh"
else
    echo "[-] Tools script not found in pack."
fi

echo ""
echo "============================================================"
echo "Customization Complete!"
echo "Please reboot your system to ensure all changes take effect."
echo "============================================================"
