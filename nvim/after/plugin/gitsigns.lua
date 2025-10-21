vim.opt.signcolumn = "yes" -- make sure the gutter is visible

require('gitsigns').setup({
    signs  = {
        add          = { text = '+' },
        change       = { text = 'c' },
        changedelete = { text = '~' },
        delete       = { text = '▁' },
        topdelete    = { text = '▔' },
        untracked    = { text = '▎' },
    },
    numhl  = false, -- try true if you prefer colored line numbers
    linehl = false, -- try true if you want the whole line highlighted
})

-- High-contrast colors (override theme-muted defaults)
local function set_gitsigns_hl()
    vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#22cc88', nocombine = true })
    vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#33aaff', nocombine = true })
    vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#ff5566', nocombine = true })
    vim.api.nvim_set_hl(0, 'GitSignsChangeDelete', { fg = '#ffb86c', nocombine = true })
    vim.api.nvim_set_hl(0, 'GitSignsUntracked', { fg = '#8888ff', nocombine = true })
    -- If you enable numhl:
    -- vim.api.nvim_set_hl(0, 'GitSignsAddNr',    { fg = '#22cc88' })
    -- vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { fg = '#33aaff' })
    -- vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { fg = '#ff5566' })
end
set_gitsigns_hl()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_gitsigns_hl })
