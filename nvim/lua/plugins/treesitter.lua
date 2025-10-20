return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        require 'nvim-treesitter.configs'.setup {
            -- Parsers installed via :TSUpdate (build hook), not on every startup
            -- If you need a new parser: :TSInstall <language>
            auto_install = true,  -- Auto-install parsers for new file types
            sync_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        }
    end
}
