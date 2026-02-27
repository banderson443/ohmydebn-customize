# OhMyDebn Customization Pack

This repository contains custom configuration and tools for the OhMyDebn Customization.

## Preview

![Customization Preview](preview.gif)

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
