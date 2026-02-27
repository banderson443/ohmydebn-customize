#!/bin/bash

# ============================================================
# OhMyDebn Customization Pack Generator
# ============================================================
# This script collects your theme, conky, and tool scripts
# into a single folder that you can copy to a USB drive
# or bake into an ISO.
# ============================================================

set -e

OUTPUT_DIR="${1:-$HOME/ohmydebn-customize}"
echo "Creating customization pack at: $OUTPUT_DIR"

# 1. Prepare Directory
if [ -d "$OUTPUT_DIR" ]; then
    echo "Cleaning up old assets in $OUTPUT_DIR..."
    # Only remove specific files/folders we know we generate, preserve .git and this script
    rm -rf "$OUTPUT_DIR/wallpaper.png"
    rm -rf "$OUTPUT_DIR/Conky"
    rm -rf "$OUTPUT_DIR/debn-pentest-setup.sh"
    rm -rf "$OUTPUT_DIR/install.sh"
    rm -rf "$OUTPUT_DIR/README.md"
else
    mkdir -p "$OUTPUT_DIR"
fi

# 2. Collect Assets
echo "Collecting assets..."

# Background
if [ -f "$HOME/Pictures/wallpaper.png" ]; then
    cp "$HOME/Pictures/wallpaper.png" "$OUTPUT_DIR/"
    echo "[+] Background image copied."
else
    echo "[-] Background image not found at $HOME/Pictures/wallpaper.png"
fi

# Conky
if [ -d "$HOME/Documents/Conky" ]; then
    cp -r "$HOME/Documents/Conky" "$OUTPUT_DIR/"
    echo "[+] Conky configuration copied."
else
    echo "[-] Conky directory not found at $HOME/Documents/Conky"
fi

# Tools Script
if [ -f "$HOME/Documents/debn-pentest-setup.sh" ]; then
    cp "$HOME/Documents/debn-pentest-setup.sh" "$OUTPUT_DIR/"
    echo "[+] Tools script copied."
else
    echo "[-] Tools script not found at $HOME/Documents/debn-pentest-setup.sh"
fi

# 3. Create the Installer Script
cat << 'INSTALLER_EOF' > "$OUTPUT_DIR/install.sh"
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
INSTALLER_EOF

# 4. Create README.md
cat << 'README_EOF' > "$OUTPUT_DIR/README.md"
# OhMyDebn Customization Pack

This repository contains custom configuration and tools for the OhMyDebn Customization.

## Contents

- **Wallpaper**: `wallpaper.png`
- **Conky Config**: `Conky/` folder with installer
- **Tools**: `debn-pentest-setup.sh` script
- **Generator**: `generate-custom-pack.sh` (to update this pack from your current system)

## How to Use

1. **Clone** this repository to your home directory on a fresh OhMyDebn installation:
   ```bash
   git clone <your-repo-url> ohmydebn-customize
   ```
2. **Enter the directory**:
   ```bash
   cd ohmydebn-customize
   ```
3. **Run the installer**:
   ```bash
   ./install.sh
   ```
4. **Reboot** your system when finished.

## how to Update

To update the pack with your current system's configuration:
1. Make changes to your system (wallpaper, conky, etc.).
2. Run the generator script inside this folder:
   ```bash
   ./generate-custom-pack.sh .
   ```
3. Commit and push the changes.

## Notes

- The installer will automatically place files in `~/Documents` and `~/.local/share/backgrounds`.
- It requires `sudo` access for package installation.
README_EOF

chmod +x "$OUTPUT_DIR/install.sh"

echo ""
echo "============================================================"
echo "Customization pack created successfully!"
echo "Location: $OUTPUT_DIR"
echo ""
echo "To use this on a new system:"
echo "1. Copy the 'ohmydebn-customize' folder to a USB drive."
echo "2. On the new system, copy it to your home folder."
echo "3. Open a terminal inside the folder and run: ./install.sh"
echo "============================================================"
