return {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        vim.opt.signcolumn = "yes"

        require('gitsigns').setup({
            signs  = {
                add          = { text = '+' },
                change       = { text = 'c' },
                changedelete = { text = '~' },
                delete       = { text = '▁' },
                topdelete    = { text = '▔' },
                untracked    = { text = '▎' },
            },
            numhl  = false,
            linehl = false,
        })

        -- High-contrast colors
        local function set_gitsigns_hl()
            vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#22cc88', nocombine = true })
            vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#33aaff', nocombine = true })
            vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#ff5566', nocombine = true })
            vim.api.nvim_set_hl(0, 'GitSignsChangeDelete', { fg = '#ffb86c', nocombine = true })
            vim.api.nvim_set_hl(0, 'GitSignsUntracked', { fg = '#8888ff', nocombine = true })
        end
        set_gitsigns_hl()
        vim.api.nvim_create_autocmd('ColorScheme', { callback = set_gitsigns_hl })
    end
}
