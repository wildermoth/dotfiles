#!/bin/bash

# Dotfiles installation script
# Creates symlinks from expected config locations to dotfiles directory

set -e

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "====================================="
echo "  Dotfiles Installation Script"
echo "====================================="
echo ""

# ============================================
# Install Dependencies
# ============================================

echo "Installing dependencies..."
echo ""

# Check if oh-my-zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "oh-my-zsh already installed ✓"
fi

# Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "Powerlevel10k already installed ✓"
fi

# Install zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions already installed ✓"
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting already installed ✓"
fi

# Install tmux if not present
if ! command -v tmux &> /dev/null; then
    echo "Installing tmux..."
    sudo apt update && sudo apt install -y tmux
else
    echo "tmux already installed ✓"
fi

# Install alacritty if not present
if ! command -v alacritty &> /dev/null; then
    echo "Installing alacritty..."
    sudo apt update && sudo apt install -y alacritty
else
    echo "alacritty already installed ✓"
fi

# Install packer.nvim (Neovim plugin manager)
PACKER_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_DIR" ]; then
    echo "Installing packer.nvim..."
    mkdir -p "$(dirname "$PACKER_DIR")"
    git clone --depth=1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
else
    echo "packer.nvim already installed ✓"
fi

echo ""
echo "Dependencies installed!"
echo ""

# ============================================
# Create Symlinks
# ============================================

echo "Creating symlinks..."
echo ""

# Create .config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Backup and symlink nvim config
if [ -e "$CONFIG_DIR/nvim" ] && [ ! -L "$CONFIG_DIR/nvim" ]; then
    echo "Backing up existing nvim config to $CONFIG_DIR/nvim.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$CONFIG_DIR/nvim" "$CONFIG_DIR/nvim.backup.$(date +%Y%m%d_%H%M%S)"
fi
echo "Creating symlink: $CONFIG_DIR/nvim -> $DOTFILES_DIR/nvim"
ln -sf "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"

# Backup and symlink zshrc
if [ -e "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "Backing up existing .zshrc to $HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
fi
echo "Creating symlink: $HOME/.zshrc -> $DOTFILES_DIR/zshrc"
ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"

# Backup and symlink tmux config
if [ -e "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
    echo "Backing up existing .tmux.conf to $HOME/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)"
fi
echo "Creating symlink: $HOME/.tmux.conf -> $DOTFILES_DIR/tmux.conf"
ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"

# Handle Alacritty config differently for WSL
if grep -qi microsoft /proc/version 2>/dev/null; then
    # Running in WSL - setup Windows Alacritty config
    # Get Windows username from WSLENV or fall back to current user
    WINDOWS_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n' | tr -d ' ')
    if [ -z "$WINDOWS_USER" ]; then
        WINDOWS_USER=$(whoami)
    fi
    WINDOWS_ALACRITTY_DIR="/mnt/c/Users/${WINDOWS_USER}/AppData/Roaming/alacritty"

    if [ -d "$WINDOWS_ALACRITTY_DIR" ]; then
        # Windows can't handle WSL symlinks properly, so we copy instead
        if [ -e "$WINDOWS_ALACRITTY_DIR/alacritty.toml" ]; then
            echo "Backing up existing Windows Alacritty config to $WINDOWS_ALACRITTY_DIR/alacritty.toml.backup.$(date +%Y%m%d_%H%M%S)"
            cp "$WINDOWS_ALACRITTY_DIR/alacritty.toml" "$WINDOWS_ALACRITTY_DIR/alacritty.toml.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        echo "Copying config to Windows Alacritty: $WINDOWS_ALACRITTY_DIR/alacritty.toml"
        cp "$DOTFILES_DIR/alacritty/alacritty-windows.toml" "$WINDOWS_ALACRITTY_DIR/alacritty.toml"
        echo "Note: Windows Alacritty uses a copy (not symlink). Run install.sh again to update after changes."
    else
        echo "Windows Alacritty directory not found, skipping Windows Alacritty config"
    fi

    # Also create WSL config (for reference)
    if [ -e "$CONFIG_DIR/alacritty" ] && [ ! -L "$CONFIG_DIR/alacritty" ]; then
        echo "Backing up existing alacritty config to $CONFIG_DIR/alacritty.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$CONFIG_DIR/alacritty" "$CONFIG_DIR/alacritty.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    echo "Creating symlink: $CONFIG_DIR/alacritty -> $DOTFILES_DIR/alacritty"
    ln -sf "$DOTFILES_DIR/alacritty" "$CONFIG_DIR/alacritty"
else
    # Not in WSL - regular Linux setup
    if [ -e "$CONFIG_DIR/alacritty" ] && [ ! -L "$CONFIG_DIR/alacritty" ]; then
        echo "Backing up existing alacritty config to $CONFIG_DIR/alacritty.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$CONFIG_DIR/alacritty" "$CONFIG_DIR/alacritty.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    echo "Creating symlink: $CONFIG_DIR/alacritty -> $DOTFILES_DIR/alacritty"
    ln -sf "$DOTFILES_DIR/alacritty" "$CONFIG_DIR/alacritty"
fi

echo ""
echo "====================================="
echo "  Installation Complete!"
echo "====================================="
echo ""
echo "Configs linked:"
echo "  - Neovim:    $CONFIG_DIR/nvim -> $DOTFILES_DIR/nvim"
echo "  - Zsh:       $HOME/.zshrc -> $DOTFILES_DIR/zshrc"
echo "  - Tmux:      $HOME/.tmux.conf -> $DOTFILES_DIR/tmux.conf"
echo "  - Alacritty: $CONFIG_DIR/alacritty -> $DOTFILES_DIR/alacritty"
echo ""
echo "Next steps:"
echo "  1. Run 'nvim' to start using your new config"
echo "  2. Restart your terminal or run 'exec zsh'"
echo "  3. Start tmux with 'tmux' command"
echo ""
