local ok, indentscope = pcall(require, "mini.indentscope")
if not ok then return end

indentscope.setup({
    -- Draw options
    draw = {
        delay = 0, -- ms before drawing starts
        -- Constant 20ms between steps (animated)
        animation = function(_next, _total) return 10 end,
        predicate = function(scope) -- only draw fully computed scopes
            return not scope.body.is_incomplete
        end,
        priority = 2,
    },

    -- Textobjects & motions
    mappings = {
        object_scope = 'ii',
        object_scope_with_border = 'ai',
        goto_top = '[i',
        goto_bottom = ']i',
    },

    -- Scope computation
    options = {
        border = 'both',
        indent_at_cursor = true,
        n_lines = 10000,
        try_as_border = false,
    },

    -- Guide character
    symbol = '│',
})

-- Recommended: disable in certain UIs/special buffers
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "help", "alpha", "dashboard", "NvimTree", "neo-tree", "oil", "lazy", "mason",
        "Trouble", "toggleterm", "TelescopePrompt", "spectre_panel", "gitcommit",
    },
    callback = function() vim.b.miniindentscope_disable = true end,
})

-- Optional: tweak color (works nicely with Rose Pine)
-- vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { link = "Comment" })
-- or set a custom color:
vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#7d2985" })

-- Optional: quick toggle
vim.keymap.set("n", "<leader>ui", function()
    vim.b.miniindentscope_disable = not vim.b.miniindentscope_disable
end, { desc = "Toggle indent scope" })
