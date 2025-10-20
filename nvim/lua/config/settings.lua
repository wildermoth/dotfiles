-- Disable netrw (use Oil instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Line wrapping
vim.opt.wrap = false

-- File handling
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = (os.getenv("HOME") or os.getenv("USERPROFILE")) .. "/.vim/undodir"
vim.opt.undofile = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- UI
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.ttimeoutlen = 0  -- Instant escape from insert mode (no delay for key codes)

-- Misc
vim.opt.isfname:append("@-@")

-- Markdown conceallevel
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "markdown.mdx" },
    callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = ""
    end,
})

-- Clear input buffer on startup to prevent stray characters
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.defer_fn(function()
            -- Flush any pending typeahead/input buffer
            vim.fn.feedkeys("", "n")
            -- Clear operator-pending state if any
            local mode = vim.fn.mode()
            if mode ~= 'n' and mode ~= 'i' then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', true)
            end
        end, 100)  -- Delay to run after all plugins load
    end,
})

-- Fix: Oil sometimes opens in operator-pending mode due to plugin race conditions
-- This autocmd forces normal mode when Oil filetype is detected
vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil",
    callback = function()
        -- Schedule twice to ensure it runs after Oil's initialization
        vim.schedule(function()
            vim.schedule(function()
                local mode = vim.api.nvim_get_mode().mode

                -- If in operator-pending mode ('no'), escape to normal
                if mode == 'no' or mode == 'v' or mode == 'V' or mode == 'i' then
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', true)
                end

                -- Clear search register and command line
                vim.fn.setreg('/', '')
                vim.api.nvim_echo({}, false, {})
            end)
        end)
    end,
})
