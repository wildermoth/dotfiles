-- Helper: show active LSP client names
local function lsp_names()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    if #clients == 0 then return '' end
    local names = {}
    for _, c in ipairs(clients) do table.insert(names, c.name) end
    return '  ' .. table.concat(names, ',')
end

-- Helper: show recording @q
local function macro_rec()
    local reg = vim.fn.reg_recording()
    if reg == '' then return '' end
    return '壘 ' .. reg -- shows like: 壘 q
end

require('lualine').setup({
    options = {
        theme                = 'auto', -- auto-detect (works well with most colorschemes)
        globalstatus         = true,   -- single statusline for the whole UI (Neovim 0.7+)
        icons_enabled        = true,
        component_separators = { left = '│', right = '│' },
        section_separators   = { left = '', right = '' }, -- comment out if you prefer flat look
        disabled_filetypes   = { 'alpha', 'dashboard', 'neo-tree', 'NvimTree', 'TelescopePrompt' },
        refresh              = { statusline = 50 }, -- snappier updates
    },
    sections = {
        lualine_a = { { 'mode', fmt = function(s) return s:sub(1, 1) end } }, -- compact mode letter
        lualine_b = {
            { 'branch', icon = '' },
            { 'diff', symbols = { added = ' ', modified = '柳', removed = ' ' } },
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
                path = 1, -- 0 = name, 1 = relative, 2 = absolute, 3 = shorten
                symbols = { modified = ' ●', readonly = '', unnamed = '[No Name]' },
            },
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
    extensions = { 'quickfix', 'man', 'lazy', 'mason', 'neo-tree', 'nvim-dap-ui', 'trouble' },
})

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
        section_separators   = { '', '' }, -- or '' for flat
    },
    sections = {
        lualine_a = { { 'mode', fmt = function(s) return s:sub(1, 1) end } },
        lualine_b = { 'branch', 'diff', { 'diagnostics', sources = { 'nvim_diagnostic' } } },
        lualine_c = {
            { 'filename', path = 1, symbols = { modified = ' ●', readonly = '', unnamed = '[No Name]' } },
            { breadcrumbs, padding = { left = 1, right = 0 } }, -- ← navic here
        },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
})
