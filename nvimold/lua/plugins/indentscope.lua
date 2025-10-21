return {
    "nvim-mini/mini.indentscope",
    branch = "stable",
    config = function()
        local ok, indentscope = pcall(require, "mini.indentscope")
        if not ok then return end

        indentscope.setup({
            draw = {
                delay = 0,
                animation = function(_next, _total) return 10 end,
                predicate = function(scope)
                    return not scope.body.is_incomplete
                end,
                priority = 2,
            },
            mappings = {
                object_scope = 'ii',
                object_scope_with_border = 'ai',
                goto_top = '[i',
                goto_bottom = ']i',
            },
            options = {
                border = 'both',
                indent_at_cursor = true,
                n_lines = 10000,
                try_as_border = false,
            },
            symbol = '│',
        })

        -- Disable in certain filetypes
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "help", "alpha", "dashboard", "NvimTree", "neo-tree", "oil", "lazy", "mason",
                "Trouble", "toggleterm", "TelescopePrompt", "spectre_panel", "gitcommit",
            },
            callback = function() vim.b.miniindentscope_disable = true end,
        })

        -- Custom color
        vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#7d2985" })

        -- Toggle keymap
        vim.keymap.set("n", "<leader>ui", function()
            vim.b.miniindentscope_disable = not vim.b.miniindentscope_disable
        end, { desc = "Toggle indent scope" })
    end
}
