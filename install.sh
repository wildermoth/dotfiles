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

# Install obsidian-cli via Homebrew
if ! command -v obsidian-cli &> /dev/null; then
    if command -v brew &> /dev/null; then
        echo "Installing obsidian-cli..."
        brew tap yakitrak/yakitrak 2>/dev/null || true
        brew install yakitrak/yakitrak/obsidian-cli
    else
        echo "Warning: Homebrew not found. Skipping obsidian-cli installation."
        echo "Install Homebrew first, then run: brew tap yakitrak/yakitrak && brew install yakitrak/yakitrak/obsidian-cli"
    fi
else
    echo "obsidian-cli already installed ✓"
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
echo "Creating symlink: $HOME/.zshrc -> $DOTFILES_DIR/configs/zsh/zshrc"
ln -sf "$DOTFILES_DIR/configs/zsh/zshrc" "$HOME/.zshrc"

# Backup and symlink tmux config
if [ -e "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
    echo "Backing up existing .tmux.conf to $HOME/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)"
fi
echo "Creating symlink: $HOME/.tmux.conf -> $DOTFILES_DIR/configs/tmux/tmux.conf"
ln -sf "$DOTFILES_DIR/configs/tmux/tmux.conf" "$HOME/.tmux.conf"

# Backup and symlink OS-specific gitconfig
if [ -e "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
    echo "Backing up existing .gitconfig to $HOME/.gitconfig.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup.$(date +%Y%m%d_%H%M%S)"
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Creating symlink: $HOME/.gitconfig -> $DOTFILES_DIR/configs/git/gitconfig-mac"
    ln -sf "$DOTFILES_DIR/configs/git/gitconfig-mac" "$HOME/.gitconfig"
elif grep -qi microsoft /proc/version 2>/dev/null; then
    echo "Creating symlink: $HOME/.gitconfig -> $DOTFILES_DIR/configs/git/gitconfig-linux (WSL)"
    ln -sf "$DOTFILES_DIR/configs/git/gitconfig-linux" "$HOME/.gitconfig"
else
    echo "Creating symlink: $HOME/.gitconfig -> $DOTFILES_DIR/configs/git/gitconfig-linux"
    ln -sf "$DOTFILES_DIR/configs/git/gitconfig-linux" "$HOME/.gitconfig"
fi

# Backup and symlink gitignore_global
if [ -e "$HOME/.gitignore_global" ] && [ ! -L "$HOME/.gitignore_global" ]; then
    echo "Backing up existing .gitignore_global to $HOME/.gitignore_global.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$HOME/.gitignore_global" "$HOME/.gitignore_global.backup.$(date +%Y%m%d_%H%M%S)"
fi
echo "Creating symlink: $HOME/.gitignore_global -> $DOTFILES_DIR/configs/git/gitignore_global"
ln -sf "$DOTFILES_DIR/configs/git/gitignore_global" "$HOME/.gitignore_global"

# Create alacritty config directory and symlink OS-specific config
mkdir -p "$CONFIG_DIR/alacritty"

if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Creating macOS-specific Alacritty config symlink"
    ln -sf "$DOTFILES_DIR/alacritty/os-mac.toml" "$CONFIG_DIR/alacritty/alacritty.toml"
elif grep -qi microsoft /proc/version 2>/dev/null; then
    echo "Creating Linux/WSL-specific Alacritty config symlink"
    ln -sf "$DOTFILES_DIR/alacritty/os-linux.toml" "$CONFIG_DIR/alacritty/alacritty.toml"

    # Try to get Windows username - try multiple methods
    WINDOWS_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n' || true)
    if [ -z "$WINDOWS_USER" ]; then
        # Fallback: use WSL username if cmd.exe not available
        WINDOWS_USER=$(whoami)
    fi

    WINDOWS_PROFILE_UNIX="/mnt/c/Users/$WINDOWS_USER"

    if [ -d "$WINDOWS_PROFILE_UNIX" ]; then
        WINDOWS_ALACRITTY_DIR="$WINDOWS_PROFILE_UNIX/AppData/Roaming/alacritty"
        mkdir -p "$WINDOWS_ALACRITTY_DIR"

        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        if [ -f "$WINDOWS_ALACRITTY_DIR/alacritty.toml" ]; then
            echo "Backing up existing Windows Alacritty config to $WINDOWS_ALACRITTY_DIR/alacritty.toml.backup.$TIMESTAMP"
            cp "$WINDOWS_ALACRITTY_DIR/alacritty.toml" "$WINDOWS_ALACRITTY_DIR/alacritty.toml.backup.$TIMESTAMP"
        fi

        # Get WSL distribution name
        if command -v wsl.exe &> /dev/null; then
            WSL_DISTRO=$(wsl.exe -l -v | grep -E '^\*' | awk '{print $2}' | tr -d '\r\n' 2>/dev/null || echo "Ubuntu")
        else
            # Fallback: extract from /etc/os-release or default to Ubuntu
            WSL_DISTRO=$(grep -oP '^NAME="\K[^"]+' /etc/os-release 2>/dev/null || echo "Ubuntu")
        fi

        echo "Syncing Windows Alacritty config files"
        # Copy base config and os-windows config to Windows
        cp "$DOTFILES_DIR/alacritty/alacritty-base.toml" "$WINDOWS_ALACRITTY_DIR/alacritty-base.toml"
        cp "$DOTFILES_DIR/alacritty/os-windows.toml" "$WINDOWS_ALACRITTY_DIR/os-windows.toml"

        # Create main config that imports local copies
        cat > "$WINDOWS_ALACRITTY_DIR/alacritty.toml" <<EOF
# Windows Alacritty configuration
# Imports local copies synced from WSL dotfiles
# Run 'cd ~/dotfiles && ./install.sh' in WSL to sync after editing base config

general.import = ["./alacritty-base.toml", "./os-windows.toml"]
EOF
    else
        echo "Windows profile directory not found, skipping Windows Alacritty sync"
    fi
else
    echo "Creating Linux-specific Alacritty config symlink"
    ln -sf "$DOTFILES_DIR/alacritty/os-linux.toml" "$CONFIG_DIR/alacritty/alacritty.toml"
fi

# For all platforms, create a symlink to the base config for easy access (optional)
ln -sf "$DOTFILES_DIR/alacritty/alacritty-base.toml" "$CONFIG_DIR/alacritty/alacritty-base.toml" 2>/dev/null || true

# Create ~/bin directory and symlink scripts
mkdir -p "$HOME/bin"
echo "Creating symlink: $HOME/bin/obs -> $DOTFILES_DIR/obs"
ln -sf "$DOTFILES_DIR/obs" "$HOME/bin/obs"

# ============================================
# Configure Obsidian CLI
# ============================================

if command -v obsidian-cli &> /dev/null; then
    echo ""
    echo "Configuring obsidian-cli..."

    # Create Obsidian config directory
    mkdir -p "$HOME/.config/obsidian"

    # Create obsidian.json config file for obsidian-cli
    if [ ! -f "$HOME/.config/obsidian/obsidian.json" ]; then
        cat > "$HOME/.config/obsidian/obsidian.json" << 'EOF'
{
  "vaults": {
    "e5c8e16c72be991f": {
      "path": "$HOME/obsidian-2025",
      "ts": 1729872000000,
      "open": true
    }
  }
}
EOF
        # Replace $HOME with actual home directory
        sed -i.bak "s|\$HOME|$HOME|g" "$HOME/.config/obsidian/obsidian.json"
        rm "$HOME/.config/obsidian/obsidian.json.bak"
        echo "Created Obsidian config file"
    else
        echo "Obsidian config file already exists ✓"
    fi

    # Set default vault
    if [ -d "$HOME/obsidian-2025" ]; then
        obsidian-cli set-default "obsidian-2025" 2>/dev/null || echo "Note: Set obsidian-cli default vault manually with: obsidian-cli set-default obsidian-2025"
    fi
fi

echo ""
echo "====================================="
echo "  Installation Complete!"
echo "====================================="
echo ""
echo "Configs linked:"
echo "  - Neovim:    $CONFIG_DIR/nvim -> $DOTFILES_DIR/nvim"
echo "  - Zsh:       $HOME/.zshrc -> $DOTFILES_DIR/configs/zsh/zshrc"
echo "  - Tmux:      $HOME/.tmux.conf -> $DOTFILES_DIR/configs/tmux/tmux.conf"
echo "  - Git:       $HOME/.gitconfig -> $DOTFILES_DIR/configs/git/gitconfig"
echo "  - Git:       $HOME/.gitignore_global -> $DOTFILES_DIR/configs/git/gitignore_global"
echo "  - Alacritty: $CONFIG_DIR/alacritty/alacritty.toml -> OS-specific config"
echo "  - Scripts:   $HOME/bin/obs -> $DOTFILES_DIR/obs"
echo ""
echo "Next steps:"
echo "  1. Run 'nvim' to start using your new config"
echo "  2. Restart your terminal or run 'exec zsh'"
echo "  3. Start tmux with 'tmux' command"
echo ""
