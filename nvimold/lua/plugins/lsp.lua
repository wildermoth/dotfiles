return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "SmiteshP/nvim-navic",
        },
        config = function()
            -- Mason setup
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                },
            })

            -- LSP setup
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local navic_ok, navic = pcall(require, 'nvim-navic')

            local function add_navic_on_attach(cfg)
                local user_on_attach = cfg.on_attach
                cfg.on_attach = function(client, bufnr)
                    if user_on_attach then user_on_attach(client, bufnr) end
                    if navic_ok and client.server_capabilities and client.server_capabilities.documentSymbolProvider then
                        navic.attach(client, bufnr)
                    end
                end
                return cfg
            end

            local has_new_api = vim.lsp and vim.lsp.config and vim.lsp.enable
            local function setup_server(name, cfg)
                cfg = cfg or {}
                cfg.capabilities = vim.tbl_deep_extend('force', cfg.capabilities or {}, capabilities)
                cfg = add_navic_on_attach(cfg)

                if has_new_api then
                    vim.lsp.config(name, cfg)
                    vim.lsp.enable(name)
                else
                    require('lspconfig')[name].setup(cfg)
                end
            end

            -- Python LSPs
            setup_server("pyright", {})
            setup_server("ruff_lsp", {
                init_options = {
                    settings = {
                        args = {},
                    },
                },
            })

            -- Lua LSP
            setup_server("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace   = { checkThirdParty = false },
                        telemetry   = { enable = false },
                    },
                },
            })

            -- LSP keymaps on attach
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local map = function(keys, fn, desc)
                        vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
                    end
                    map("gd", vim.lsp.buf.definition, "Go to definition")
                    map("gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("gr", vim.lsp.buf.references, "References")
                    map("gi", vim.lsp.buf.implementation, "Go to implementation")
                    map("<leader>rn", vim.lsp.buf.rename, "Rename")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    map("K", vim.lsp.buf.hover, "Hover")
                    map("]d", vim.diagnostic.goto_next, "Next diagnostic")
                    map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
                end,
            })
        end
    },
}
