-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'


    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }


    use {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end
    }

    use({
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup()
        end,
    })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    -- LSP + installer
    use "neovim/nvim-lspconfig"
    use { "williamboman/mason.nvim", run = ":MasonUpdate" }
    use "williamboman/mason-lspconfig.nvim"

    -- Completion (minimal)
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp"
    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"

    -- Formatting runner (optional but convenient)
    use "stevearc/conform.nvim"
    use { "nvim-mini/mini.indentscope", branch = "stable" }
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons' }, -- for nice icons
    }
    use { 'SmiteshP/nvim-navic' }
    use({
        "epwalsh/obsidian.nvim",
        tag = "*", -- recommended, use latest release instead of latest commit
        requires = {
            -- Required.
            "nvim-lua/plenary.nvim",


            -- see below for full list of optional dependencies 👇

        },
        config = function()
            require("obsidian").setup({
                workspaces = {
                    {
                        name = "personal",

                        path = "/mnt/c/Users/James/Documents/GitHub/obsidian",
                    }
                },
            })
        end,
    })
end)
