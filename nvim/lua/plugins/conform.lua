return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                python = { "ruff_format" },
                lua = { "stylua" },
            },
        })

        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(args)
                require("conform").format({ bufnr = args.buf, lsp_fallback = true })
            end,
        })
    end
}
