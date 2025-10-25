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
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp", -- optional, for completion
            "nvim-telescope/telescope.nvim", -- optional, for search
        },
        config = function()
            require("obsidian").setup({
                workspaces = {
                    {
                        name = "personal",
                        path = "~/obsidian-2025",
                    }
                },

                -- Disable obsidian.nvim's frontmatter management (we handle it ourselves)
                disable_frontmatter = true,

                -- Daily notes configuration
                daily_notes = {
                    folder = "",
                    date_format = "%Y-%m-%d",
                    alias_format = "%B %d, %Y",
                    template = "Daily-nvim.md",
                },

                -- Templates configuration
                templates = {
                    folder = "_ignore/Templates",
                    date_format = "%Y-%m-%d",
                    time_format = "%H:%M",
                    substitutions = {
                        -- Long date format matching Obsidian
                        date_long = function()
                            local day = tonumber(os.date("%d"))
                            local suffix = "th"
                            if day == 1 or day == 21 or day == 31 then
                                suffix = "st"
                            elseif day == 2 or day == 22 then
                                suffix = "nd"
                            elseif day == 3 or day == 23 then
                                suffix = "rd"
                            end
                            return os.date("%A, %B " .. day .. suffix .. " %Y, %I:%M:%S %p")
                        end,
                        -- Daily tag in format: periodic/daily/YYYY/MM/DD
                        daily_tag = function()
                            return "periodic/daily/" .. os.date("%Y/%m/%d")
                        end,
                        -- Weekly note link: W01-2025 format
                        weekly_note = function()
                            return "W" .. os.date("%V") .. "-" .. os.date("%Y")
                        end,
                        -- Tomorrow's date
                        tomorrow = function()
                            return os.date("%Y-%m-%d", os.time() + 86400)
                        end,
                        -- Yesterday's date
                        yesterday = function()
                            return os.date("%Y-%m-%d", os.time() - 86400)
                        end,
                    },
                },

                -- Where to create new notes
                new_notes_location = "notes_subdir",
                notes_subdir = "",

                -- Note ID and path configuration
                note_id_func = function(title)
                    -- For new notes without title, use timestamp (YYYYMMDDHHmm)
                    if title == nil or title == "" then
                        return tostring(os.date("%Y%m%d%H%M"))
                    end
                    -- For notes with title, sanitize it
                    return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                end,

                note_path_func = function(spec)
                    -- Save to the configured directory (vault root via notes_subdir = "")
                    local path = spec.dir / tostring(spec.id)
                    return path:with_suffix(".md")
                end,

                -- Completion configuration
                completion = {
                    nvim_cmp = true,
                    min_chars = 2,
                },

                -- UI configuration
                ui = {
                    enable = true,
                    checkboxes = {
                        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                        ["x"] = { char = "", hl_group = "ObsidianDone" },
                    },
                },

                -- Attachments configuration
                attachments = {
                    img_folder = "_ignore/Attachments",
                },

                -- Follow links with gf
                follow_url_func = function(url)
                    vim.fn.jobstart({"xdg-open", url})
                end,
            })
        end,
    })
end)
