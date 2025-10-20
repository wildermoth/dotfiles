return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local navic_ok, navic = pcall(require, 'nvim-navic')

        local function breadcrumbs()
            if not (navic_ok and navic.is_available()) then return '' end
            local loc = navic.get_location()
            return (loc and #loc > 0) and loc or ''
        end

        require('lualine').setup({
            options = {
                theme                = 'auto',
                globalstatus         = true,
                component_separators = { '│', '│' },
                section_separators   = { '', '' },
            },
            sections = {
                lualine_a = { { 'mode', fmt = function(s) return s:sub(1, 1) end } },
                lualine_b = { 'branch', 'diff', { 'diagnostics', sources = { 'nvim_diagnostic' } } },
                lualine_c = {
                    { 'filename', path = 1, symbols = { modified = ' ●', readonly = '', unnamed = '[No Name]' } },
                    { breadcrumbs, padding = { left = 1, right = 0 } },
                },
                lualine_x = { 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' },
            },
        })
    end
}
