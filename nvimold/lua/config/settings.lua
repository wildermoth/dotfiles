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
vim.opt.clipboard = "unnamedplus"

-- Markdown conceallevel
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "markdown.mdx" },
    callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = ""
    end,
})