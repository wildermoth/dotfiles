# Dotfiles Repository Guide

## Overview

This is a personal dotfiles repository optimized for development workflows across WSL2, Linux, and macOS environments. It focuses on terminal productivity with Neovim, Tmux, Zsh, and Alacritty.

**Key Statistics:**
- Configuration files: 5 main components (nvim, tmux, zsh, alacritty, zshrc)
- Neovim plugins: 18 plugins managed with lazy.nvim
- Platform support: WSL2, Linux, macOS with intelligent detection
- Installation: Single install.sh script with backup safety

---

## 1. Repository Structure

```
dotfiles/
├── install.sh              # Main installation script
├── nvim/                   # Neovim configuration (lazy.nvim based)
│   ├── init.lua           # Entry point
│   ├── lazy-lock.json     # Plugin version lock file
│   └── lua/
│       ├── config/        # Core Neovim settings
│       │   ├── settings.lua    # Editor options, autocmds
│       │   ├── keymaps.lua     # Global keybindings
│       │   └── lazy.lua        # lazy.nvim bootstrap
│       └── plugins/       # Individual plugin specs (auto-loaded)
│           ├── lsp.lua
│           ├── completion.lua
│           ├── telescope.lua
│           ├── colorscheme.lua
│           ├── conform.lua     # Formatting
│           ├── harpoon.lua     # File navigation marks
│           ├── treesitter.lua
│           ├── gitsigns.lua
│           ├── fugitive.lua    # Git integration
│           ├── undotree.lua
│           ├── lualine.lua     # Status line
│           ├── oil.lua         # File explorer
│           ├── indentscope.lua
│           └── obsidian.lua    # Markdown/Obsidian support
├── tmux.conf               # Tmux configuration
├── zshrc                   # Zsh shell configuration
└── alacritty/
    ├── alacritty.toml           # Linux/macOS config
    └── alacritty-windows.toml   # Windows + WSL config
```

---

## 2. Installation Process

### How it Works

The `install.sh` script is idempotent and follows this sequence:

1. **Dependency Installation**
   - oh-my-zsh (if not present)
   - Powerlevel10k theme
   - zsh-autosuggestions plugin
   - zsh-syntax-highlighting plugin
   - tmux (via apt)
   - alacritty (via apt)

2. **Symlink Creation**
   - Creates `~/.config/nvim` → `dotfiles/nvim`
   - Creates `~/.zshrc` → `dotfiles/zshrc`
   - Creates `~/.tmux.conf` → `dotfiles/tmux.conf`
   - Creates `~/.config/alacritty` → `dotfiles/alacritty`

3. **Backup Safety**
   - Backs up existing configs with timestamp: `config.backup.20251020_223000`
   - Only backs up if target isn't already a symlink
   - Uses `set -e` for error safety

### Running Installation

```bash
cd ~/dotfiles
./install.sh
```

---

## 3. Platform-Specific Handling

### WSL2 Detection

The script detects WSL by checking `/proc/version` for "microsoft":

```bash
if grep -qi microsoft /proc/version 2>/dev/null; then
    # WSL-specific logic
fi
```

### Alacritty WSL Quirk

**Why two Alacritty configs?**

- **Problem:** Windows Alacritty can't follow WSL symlinks (filesystem limitation)
- **Solution:** 
  - `alacritty-windows.toml`: Copied (not symlinked) to Windows user's `AppData/Roaming/alacritty`
  - `alacritty.toml`: Symlinked in WSL for reference/consistency
  - Windows username auto-detected via `cmd.exe /c "echo %USERNAME%"`

### Platform Differences

| Component | WSL | Linux | macOS |
|-----------|-----|-------|-------|
| Alacritty | Copied to Windows | Symlinked | Symlinked |
| Font | JetBrainsMono (Windows) | MesloLGS NF | MesloLGS NF |
| Tmux | Uses clip.exe for copy | Standard | Standard |
| Shell | Launches via wsl.exe | Direct /usr/bin/zsh | Direct /usr/bin/zsh |

---

## 4. Neovim Configuration Structure

### Architecture

Uses **lazy.nvim** plugin manager with modular plugin loading:
- **Bootstrap** (`lazy.lua`): Clones lazy.nvim if needed
- **Auto-loading**: All files in `lua/plugins/` are automatically loaded
- **Dependency management**: Each plugin declares dependencies (e.g., LSP depends on Mason)

### Initialization Flow

1. `init.lua` runs first
2. Loads `config/settings.lua` (editor options, autocmds)
3. Loads `config/keymaps.lua` (global leader bindings)
4. Loads `config/lazy.lua` (bootstraps lazy.nvim, loads all plugins)
5. Manual oil.nvim setup (requires plugin to load first)

### Core Settings (`lua/config/settings.lua`)

**Editor behavior:**
- Relative line numbers with absolute current line
- 4-space indentation, expandtabs
- No swapfiles/backups, persistent undo
- 256-color terminal, sign column always visible
- Instant escape from insert mode (`ttimeoutlen = 0`)
- Markdown conceallevel = 2 for better readability

**Treesitter compiler:** Supports zig, gcc, clang, cc

### Global Keymaps (`lua/config/keymaps.lua`)

**Leader: Space**

| Key | Function |
|-----|----------|
| `-` | Oil (file explorer) |
| `<leader>rr` | Run Python file |
| `<leader>rt` | Run Python in terminal split |
| `<leader>al` | Open Alacritty in project root |
| `<leader>b` | Switch to alternate buffer |
| `<leader>lg` | Git log in right vsplit terminal |
| `<leader>os` | Obsidian search |
| `t` mode: `<Esc>` | Exit terminal mode to normal |

---

## 5. Plugin Architecture

### Plugin Dependency Tree

```
lazy.nvim (bootstrap)
├── LSP Ecosystem
│   ├── nvim-lspconfig
│   ├── mason.nvim (LSP installer)
│   ├── mason-lspconfig.nvim
│   ├── nvim-navic (breadcrumb)
│   └── nvim-cmp (completion)
│       ├── cmp-nvim-lsp
│       ├── LuaSnip (snippets)
│       └── cmp_luasnip
├── Navigation
│   ├── telescope.nvim (fuzzy finder)
│   │   └── plenary.nvim
│   ├── harpoon (marks for 4 files)
│   ├── oil.nvim (file browser)
│   └── nvim-web-devicons
├── Git Integration
│   ├── vim-fugitive
│   └── gitsigns.nvim
├── Editor Enhancements
│   ├── nvim-treesitter (syntax)
│   ├── conform.nvim (formatting)
│   ├── lualine.nvim (status line)
│   ├── mini.indentscope (indent guides)
│   └── undotree (undo history)
├── Theming
│   └── rose-pine (colorscheme)
└── Knowledge Management
    └── obsidian.nvim (markdown/vault)
```

### LSP Configuration

**Auto-installed servers:**
- `lua_ls` (Lua)
- `pyright` (Python type checking)
- `ruff_lsp` (Python linting/formatting)

**LSP Keymaps (on attach):**
- `gd` - Definition
- `gD` - Declaration
- `gr` - References
- `gi` - Implementation
- `<leader>rn` - Rename
- `<leader>ca` - Code actions
- `K` - Hover
- `]d` / `[d` - Next/prev diagnostic

**Breadcrumb (nvim-navic):**
- Integrated into lualine status bar
- Shows current code context (function, class, etc.)

### Completion Setup

**Sources (in priority order):**
1. nvim_lsp - LSP completions
2. luasnip - Snippet expansions
3. buffer - Open buffer words
4. path - File paths

**Mappings:**
- `<Tab>` - Next item
- `<S-Tab>` - Prev item
- `<C-Space>` - Force completion menu
- `<CR>` - Confirm selection

### Formatting (conform.nvim)

**Auto-format on save:**
- Python: `ruff_format`
- Lua: `stylua`
- LSP fallback if formatter unavailable

---

## 6. Terminal Configurations

### Tmux (`tmux.conf`)

**Key Design Decisions:**
- Prefix: `Ctrl-a` (Vim-friendly, easier than Ctrl-b)
- Mouse: Enabled for pane selection
- History: 100,000 lines
- Colors: Catppuccin Mocha theme matching Neovim

**Color scheme:** Dark background (#1e1e2e) with vibrant accents
- Active pane border: Blue (#89b4fa)
- Status bar: Green time (#a6e3a1), Pink date (#f5c2e7)
- Window status: Bold blue for active, dim gray for inactive

**Navigation (no prefix needed):**
- `Alt+Arrow` - Switch panes
- `|` - Vertical split (preserves path)
- `-` - Horizontal split (preserves path)
- `r` - Reload config

**Special handling:**
- `Ctrl-a` prefix to tmux for nested sessions
- Copy to Windows clipboard via `clip.exe` (WSL-aware)
- Focus events enabled for Vim (`:FocusGained`/`:FocusLost`)

### Zsh (`zshrc`)

**Theme & Plugins:**
- Theme: Powerlevel10k (instant prompt enabled)
- Plugins: git, z, fzf, sudo, colored-man-pages, zsh-autosuggestions, zsh-syntax-highlighting
- NVM support (Node version manager)

**Environment:**
- Editor: nvim
- Git pager: cat (no paging)
- PATH: Homebrew support (both Apple Silicon and Intel)
- Google Cloud SDK support (conditional)

**Note:** Line 162-169 has duplicate Powerlevel10k sourcing (should be cleaned up)

### Alacritty

#### Linux/macOS (`alacritty.toml`)

**Display:**
- Font: MesloLGS NF 11pt (Powerlevel10k recommended)
- Window padding: 10px
- Opacity: 95%
- Colors: Catppuccin Mocha (matching tmux/nvim)

#### Windows + WSL (`alacritty-windows.toml`)

**Differences:**
- Font: JetBrainsMono Nerd Font 12pt (Windows render better)
- Blur enabled, opacity 93%
- Custom keyboard bindings:
  - Ctrl+Shift+C/V for Copy/Paste (Windows standard)
  - Ctrl+Left/Right for word jumps
  - Ctrl+Backspace for delete word
- Shell: `wsl.exe` with Ubuntu distro, zsh login shell
- Working directory: Windows user home (C:/Users/james)

---

## 7. Key Architecture Decisions

### Why lazy.nvim?

- **On-demand loading:** Plugins load only when needed
- **Dependency resolution:** Automatic dependency tracking
- **Version lock:** `lazy-lock.json` ensures reproducible setups
- **Fast startup:** Minimal bootstrap time

### Why split Alacritty configs?

Windows filesystem limitations prevent symlinks across WSL boundary:
- Install script detects WSL, copies Windows config
- Manual copying required after changes (noted in install output)
- Maintains separate font/shell settings per platform

### Why Catppuccin Mocha everywhere?

- **Consistency:** Same color palette in terminal, editor, tmux, shell
- **Vibrant but readable:** Dark background prevents eye strain
- **Tool support:** Wide plugin/app support for this theme

### Why Ctrl-a for Tmux?

- Natural for Vim keybinding muscle memory
- Left-hand friendly
- Reduces conflict with default Ctrl-b interactions
- Nested session support (send via `Ctrl-a Ctrl-a`)

### Why Oil over NERDTree?

- Lightweight, maintains cursor/scroll position
- Edit-based: Navigate and manipulate files like text
- Single file explorer instance
- Better integration with modern Neovim

---

## 8. Extending These Dotfiles

### Adding a New Neovim Plugin

1. Create file in `lua/plugins/myfeature.lua`:
```lua
return {
    "owner/repo",
    dependencies = { "other/plugin" },
    config = function()
        -- Setup code
    end
}
```

2. lazy.nvim auto-loads on restart
3. Update lock file: `:Lazy` → `u` (update)

### Adding LSP Support

1. Edit `lua/plugins/lsp.lua`
2. Add to `ensure_installed` list in mason-lspconfig
3. Add server setup via `setup_server()`

### Modifying Keybindings

- Global: `lua/config/keymaps.lua`
- Plugin-specific: Add `vim.keymap.set()` in plugin's config function
- LSP: `LspAttach` autocmd in `lua/plugins/lsp.lua`

### Updating Plugin Versions

```bash
cd ~/.config/nvim
nvim  # Open Neovim
# :Lazy  (open lazy.nvim UI)
# u      (update all)
# q      (quit)
```

Lock file updates automatically.

### Creating Platform-Specific Configs

Use this pattern in any lua file:
```lua
local is_wsl = vim.fn.system("uname -r"):find("microsoft") ~= nil
local is_mac = vim.fn.system("uname"):find("Darwin") ~= nil

if is_wsl then
    -- WSL-specific setup
elseif is_mac then
    -- macOS-specific setup
else
    -- Linux-specific setup
end
```

---

## 9. Common Tasks

### Reinstalling After Config Changes

```bash
cd ~/dotfiles
./install.sh
# Follow prompts (backs up existing configs)
```

### Updating a Single Plugin

```
:Lazy show <plugin-name>
:Lazy update <plugin-name>
```

### Regenerating LSP Setup

```
:Mason  # Open Mason UI
# Install/remove servers
# Restart Neovim
```

### Backup Current Config

```bash
tar czf dotfiles-backup-$(date +%Y%m%d).tar.gz \
  ~/.config/nvim \
  ~/.config/alacritty \
  ~/.config/tmux.conf \
  ~/.zshrc
```

### Testing Install on Fresh System

```bash
# Simulate fresh install
rm -rf ~/.config/nvim ~/.zshrc ~/.tmux.conf ~/.config/alacritty
./install.sh
```

---

## 10. Troubleshooting

### Issue: Powerlevel10k not showing in new terminal

**Solution:** Re-source p10k configuration:
```bash
exec zsh
# or
p10k configure
```

### Issue: Colors broken in Tmux

**Check:**
```bash
echo $TERM  # Should be tmux-256color or alacritty
tmux show-options -g default-terminal
```

**Fix:** Restart Tmux:
```bash
tmux kill-server
tmux
```

### Issue: LSP not working in new buffer

**Check:** 
```vim
:LspInfo  " Shows attached LSP servers
:Mason    " Check if server is installed
```

**Fix:**
```vim
:LspStart pyright  " Manually start server
# or restart nvim
```

### Issue: Alacritty config not updating in Windows

**Note:** Windows Alacritty uses copied config, not symlink.

**Solution:** Re-run install.sh:
```bash
./install.sh
# Restarts Alacritty after copying
```

---

## 11. Dependencies Summary

### System Requirements

- **OS:** WSL2/Linux/macOS
- **Shell:** Zsh (installed via install.sh)
- **Terminal:** Alacritty (installed via install.sh)
- **Multiplexer:** Tmux (installed via install.sh)
- **Editor:** Neovim 0.9+ (assumed pre-installed)

### Optional Dependencies

- **Git:** For fugitive, gitsigns
- **Python:** For Python LSP/formatting
- **Node/npm:** For some LSP servers
- **Compilers:** gcc/clang (for Treesitter)

### Fonts Required

- **Linux/macOS:** MesloLGS NF (Nerd Font variant for Powerlevel10k)
- **Windows:** JetBrainsMono Nerd Font

Install via:
```bash
# macOS
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font

# Linux (manual)
# Download from nerdfonts.com
```

---

## 12. File Manifest

| File | Purpose | Managed By |
|------|---------|-----------|
| `install.sh` | Installation orchestration | Manual edits |
| `nvim/init.lua` | Neovim entry point | Manual edits |
| `nvim/lua/config/settings.lua` | Editor options | Manual edits |
| `nvim/lua/config/keymaps.lua` | Global keybindings | Manual edits |
| `nvim/lua/config/lazy.lua` | lazy.nvim bootstrap | Manual (don't edit) |
| `nvim/lua/plugins/*.lua` | Plugin specs | Manual edits |
| `nvim/lazy-lock.json` | Plugin versions | Auto-generated, commit to git |
| `tmux.conf` | Tmux settings | Manual edits |
| `zshrc` | Zsh settings | Manual edits |
| `alacritty/alacritty.toml` | Linux/macOS terminal | Manual edits |
| `alacritty/alacritty-windows.toml` | Windows terminal | Manual edits |

---

## 13. Git Workflow

All files are tracked in git. Workflow:

```bash
# Edit configs
vim ~/.config/nvim/lua/config/keymaps.lua

# Update lazy.nvim lock file
nvim
:Lazy update
# Plugins auto-update lazy-lock.json

# Commit changes
cd ~/dotfiles
git add -A
git commit -m "Update: Add new keybinding for feature X"
git push
```

On new machine:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

---

## 14. Performance Notes

**Startup time:** ~300-500ms (depends on LSP initialization)

**Optimization tips:**
- Lazy loading handles plugin load time
- lazy.nvim defaults to not auto-checking for updates
- LSP starts on first attach, not at startup

**Heavy plugins:**
- Treesitter: Only parses visible buffers
- Telescope: Index built on first search

---

## 15. Future Improvements

Suggested enhancements:
- [ ] Fix duplicate Powerlevel10k sourcing in zshrc (lines 162-169)
- [ ] Add git config management to install.sh
- [ ] Separate WSL/macOS-specific zsh setup to plugin files
- [ ] Add Docker/devcontainer support to install script
- [ ] Document custom telescope pickers
- [ ] Add language-specific formatter configs
- [ ] Create setup guide for new machine with prerequisites checklist

---

Generated: 2025-10-20
Last Updated: When lazy.nvim lock file changed
