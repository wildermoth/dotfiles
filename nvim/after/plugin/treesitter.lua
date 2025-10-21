require('nvim-treesitter.install').compilers = { "zig", "gcc", "clang", "cc" }

require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "c", "lua", "javascript", "python", "typescript", "vim", "vimdoc", "query", "markdown", "markdown_inline", "json", "xml", "html" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    auto_install = true,

    highlight = {
        enable = true,

        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            node_incremental = "v",
            node_decremental = "V",
        },
    },
}
