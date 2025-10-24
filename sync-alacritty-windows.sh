#!/bin/bash
# Quick sync script for Windows Alacritty config
# Run this after editing alacritty-base.toml or os-windows.toml

set -e

DOTFILES_DIR="$HOME/dotfiles"
WINDOWS_USER=$(whoami)
WINDOWS_ALACRITTY_DIR="/mnt/c/Users/$WINDOWS_USER/AppData/Roaming/alacritty"

if [ ! -d "$WINDOWS_ALACRITTY_DIR" ]; then
    echo "Error: Windows Alacritty directory not found at $WINDOWS_ALACRITTY_DIR"
    exit 1
fi

echo "Syncing Alacritty configs to Windows..."
cp "$DOTFILES_DIR/alacritty/alacritty-base.toml" "$WINDOWS_ALACRITTY_DIR/alacritty-base.toml"
cp "$DOTFILES_DIR/alacritty/os-windows.toml" "$WINDOWS_ALACRITTY_DIR/os-windows.toml"

echo "✓ Synced! Restart Alacritty to apply changes."
