#!/bin/bash
# Quick sync script for Windows configs
# Run this after editing alacritty configs or AHK scripts

set -e

DOTFILES_DIR="$HOME/dotfiles"
WINDOWS_USER=$(whoami)
WINDOWS_PROFILE="/mnt/c/Users/$WINDOWS_USER"
WINDOWS_ALACRITTY_DIR="$WINDOWS_PROFILE/AppData/Roaming/alacritty"
WINDOWS_AHK_DIR="$WINDOWS_PROFILE/Desktop/AHK Scripts"

echo "Syncing configs to Windows..."

# Sync Alacritty configs
if [ -d "$WINDOWS_ALACRITTY_DIR" ]; then
    echo "  - Alacritty configs..."
    cp "$DOTFILES_DIR/alacritty/alacritty-base.toml" "$WINDOWS_ALACRITTY_DIR/alacritty-base.toml"
    cp "$DOTFILES_DIR/alacritty/os-windows.toml" "$WINDOWS_ALACRITTY_DIR/os-windows.toml"
else
    echo "  ⚠ Windows Alacritty directory not found, skipping"
fi

# Sync AHK script
if [ -d "$WINDOWS_PROFILE" ]; then
    echo "  - AHK script..."
    mkdir -p "$WINDOWS_AHK_DIR"
    cp "$DOTFILES_DIR/keyboard/extend_layer_wide_std.ahk" "$WINDOWS_AHK_DIR/extend_layer_wide_std.ahk"
else
    echo "  ⚠ Windows profile not found, skipping AHK sync"
fi

echo "✓ Synced! Restart applications to apply changes."
