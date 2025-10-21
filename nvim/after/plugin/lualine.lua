-- Helper: show active LSP client names
local function lsp_names()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if #clients == 0 then return '' end
    local names = {}
    for _, c in ipairs(clients) do table.insert(names, c.name) end
    return '  ' .. table.concat(names, ',')
end

local function macro_rec()
    local reg = vim.fn.reg_recording()
    if reg == '' then return '' end
    return '壘 ' .. reg
end

local navic_ok, navic = pcall(require, 'nvim-navic')

local function breadcrumbs()
    if not (navic_ok and navic.is_available()) then return '' end
    local loc = navic.get_location()
    return (loc and #loc > 0) and loc or ''
end

local function tab_title(name, context)
    local tabnr = context.tabnr or 0
    local label = (name ~= '' and name) or '[No Name]'
    local icon = context.current and '' or ''
    return string.format('%s %d %s', icon, tabnr, label)
end

require('lualine').setup({
    options = {
        theme                = 'auto',
        globalstatus         = true,
        icons_enabled        = true,
        component_separators = { left = '│', right = '│' },
        section_separators   = { left = '', right = '' },
        disabled_filetypes   = { 'alpha', 'dashboard', 'neo-tree', 'NvimTree', 'TelescopePrompt' },
        refresh              = { statusline = 50, tabline = 200 },
    },
    sections = {
        lualine_a = {
            { 'mode', fmt = function(s) return s:sub(1, 1) end },
        },
        lualine_b = {
            { 'branch', icon = '' },
            { 'diff', symbols = { added = ' ', modified = 'M', removed = ' ' } },
            {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
                colored = true,
            },
        },
        lualine_c = {
            {
                'filename',
                file_status = true,
                newfile = true,
                path = 1,
                symbols = { modified = ' ●', readonly = '', unnamed = '[No Name]' },
            },
            { breadcrumbs, padding = { left = 1, right = 0 } },
        },
        lualine_x = {
            { lsp_names, separator = '│' },
            { macro_rec },
            { 'encoding', fmt = string.upper, cond = function() return vim.o.encoding ~= 'utf-8' end },
            { 'fileformat', icons_enabled = true },
            { 'filetype' },
        },
        lualine_y = { { 'progress' } },
        lualine_z = { { 'location' } },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {
        lualine_a = {
            {
                'tabs',
                mode = 1,
                max_length = vim.o.columns,
                use_mode_colors = true,
                fmt = tab_title,
                tabs_color = {
                    active = 'lualine_a_normal',
                    inactive = 'lualine_b_normal',
                },
                show_modified_status = true,
            },
        },
        lualine_z = {
            {
                'windows',
                show_filename_only = true,
                show_modified_status = true,
            },
        },
    },
    extensions = { 'quickfix', 'man', 'lazy', 'mason', 'neo-tree', 'nvim-dap-ui', 'trouble' },
})
