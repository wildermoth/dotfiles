-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/james/.cache/nvim/packer_hererocks/2.1.1703358377/share/lua/5.1/?.lua;/home/james/.cache/nvim/packer_hererocks/2.1.1703358377/share/lua/5.1/?/init.lua;/home/james/.cache/nvim/packer_hererocks/2.1.1703358377/lib/luarocks/rocks-5.1/?.lua;/home/james/.cache/nvim/packer_hererocks/2.1.1703358377/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/james/.cache/nvim/packer_hererocks/2.1.1703358377/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["conform.nvim"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/conform.nvim",
    url = "https://github.com/stevearc/conform.nvim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  harpoon = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/theprimeagen/harpoon"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["mini.indentscope"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/mini.indentscope",
    url = "https://github.com/nvim-mini/mini.indentscope"
  },
  neovim = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\26colorscheme rose-pine\bcmd\bvim\0" },
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/neovim",
    url = "https://github.com/rose-pine/neovim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-navic"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/nvim-navic",
    url = "https://github.com/SmiteshP/nvim-navic"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["obsidian.nvim"] = {
    config = { "\27LJ\2\nÏ\1\0\0\b\0\n\a\"6\0\0\0006\2\1\0009\2\2\2'\4\3\0B\2\2\0A\0\0\2'\1\4\0\b\0\0\0X\2\4€\b\0\1\0X\2\2€\t\0\2\0X\2\2€'\1\5\0X\2\v€\b\0\3\0X\2\2€\t\0\4\0X\2\2€'\1\6\0X\2\5€\b\0\5\0X\2\2€\t\0\6\0X\2\1€'\1\a\0006\2\1\0009\2\2\2'\4\b\0\18\5\0\0\18\6\1\0'\a\t\0&\4\a\4D\2\2\0\21 %Y, %I:%M:%S %p\f%A, %B \ard\and\ast\ath\a%d\tdate\aos\rtonumber\2*>\4,\6.D\0\0\4\0\4\0\a'\0\0\0006\1\1\0009\1\2\1'\3\3\0B\1\2\2&\0\1\0L\0\2\0\r%Y/%m/%d\tdate\aos\20periodic/daily/I\0\0\6\0\6\0\f'\0\0\0006\1\1\0009\1\2\1'\3\3\0B\1\2\2'\2\4\0006\3\1\0009\3\2\3'\5\5\0B\3\2\2&\0\3\0L\0\2\0\a%Y\6-\a%V\tdate\aos\6W@\0\0\5\0\4\1\b6\0\0\0009\0\1\0'\2\2\0006\3\0\0009\3\3\3B\3\1\2\22\3\0\3D\0\3\0\ttime\r%Y-%m-%d\tdate\aos€Æ\n@\0\0\5\0\4\1\b6\0\0\0009\0\1\0'\2\2\0006\3\0\0009\3\3\3B\3\1\2\23\3\0\3D\0\3\0\ttime\r%Y-%m-%d\tdate\aos€Æ\n\1\0\1\6\0\n\0\23\n\0\0\0X\1\2€\a\0\0\0X\1\6€6\1\1\0006\3\2\0009\3\3\3'\5\4\0B\3\2\0C\1\0\0\18\3\0\0009\1\5\0'\4\6\0'\5\a\0B\1\4\2\18\3\1\0009\1\5\1'\4\b\0'\5\0\0B\1\4\2\18\3\1\0009\1\t\1D\1\2\0\nlower\18[^A-Za-z0-9-]\6-\6 \tgsub\15%Y%m%d%H%M\tdate\aos\rtostring\5K\0\1\6\0\5\0\t9\1\0\0006\2\1\0009\4\2\0B\2\2\2#\1\2\1\18\4\1\0009\2\3\1'\5\4\0D\2\3\0\b.md\16with_suffix\aid\rtostring\bdir@\0\1\4\0\4\0\a6\1\0\0009\1\1\0019\1\2\0015\3\3\0>\0\2\3B\1\2\1K\0\1\0\1\2\0\0\rxdg-open\rjobstart\afn\bvimœ\6\1\0\6\0(\0-6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0004\3\3\0005\4\3\0>\4\1\3=\3\5\0025\3\6\0=\3\a\0025\3\b\0005\4\n\0003\5\t\0=\5\v\0043\5\f\0=\5\r\0043\5\14\0=\5\15\0043\5\16\0=\5\17\0043\5\18\0=\5\19\4=\4\20\3=\3\21\0023\3\22\0=\3\23\0023\3\24\0=\3\25\0025\3\26\0=\3\27\0025\3\28\0005\4\30\0005\5\29\0=\5\31\0045\5 \0=\5!\4=\4\"\3=\3#\0025\3$\0=\3%\0023\3&\0=\3'\2B\0\2\1K\0\1\0\20follow_url_func\0\16attachments\1\0\1\15img_folder\24_ignore/Attachments\aui\15checkboxes\6x\1\0\2\rhl_group\17ObsidianDone\tchar\5\6 \1\0\0\1\0\2\rhl_group\17ObsidianTodo\tchar\tó°„±\1\0\1\venable\2\15completion\1\0\2\14min_chars\3\2\rnvim_cmp\2\19note_path_func\0\17note_id_func\0\14templates\18substitutions\14yesterday\0\rtomorrow\0\16weekly_note\0\14daily_tag\0\14date_long\1\0\0\0\1\0\3\16time_format\n%H:%M\16date_format\r%Y-%m-%d\vfolder\22_ignore/Templates\16daily_notes\1\0\4\17alias_format\14%B %d, %Y\rtemplate\18Daily-nvim.md\16date_format\r%Y-%m-%d\vfolder\5\15workspaces\1\0\3\23new_notes_location\17notes_subdir\17notes_subdir\5\24disable_frontmatter\2\1\0\2\tname\rpersonal\tpath\20~/obsidian-2025\nsetup\robsidian\frequire\0" },
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/obsidian.nvim",
    url = "https://github.com/epwalsh/obsidian.nvim"
  },
  ["oil.nvim"] = {
    config = { "\27LJ\2\n1\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\boil\frequire\0" },
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/oil.nvim",
    url = "https://github.com/stevearc/oil.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  undotree = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/james/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: neovim
time([[Config for neovim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\26colorscheme rose-pine\bcmd\bvim\0", "config", "neovim")
time([[Config for neovim]], false)
-- Config for: oil.nvim
time([[Config for oil.nvim]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\boil\frequire\0", "config", "oil.nvim")
time([[Config for oil.nvim]], false)
-- Config for: obsidian.nvim
time([[Config for obsidian.nvim]], true)
try_loadstring("\27LJ\2\nÏ\1\0\0\b\0\n\a\"6\0\0\0006\2\1\0009\2\2\2'\4\3\0B\2\2\0A\0\0\2'\1\4\0\b\0\0\0X\2\4€\b\0\1\0X\2\2€\t\0\2\0X\2\2€'\1\5\0X\2\v€\b\0\3\0X\2\2€\t\0\4\0X\2\2€'\1\6\0X\2\5€\b\0\5\0X\2\2€\t\0\6\0X\2\1€'\1\a\0006\2\1\0009\2\2\2'\4\b\0\18\5\0\0\18\6\1\0'\a\t\0&\4\a\4D\2\2\0\21 %Y, %I:%M:%S %p\f%A, %B \ard\and\ast\ath\a%d\tdate\aos\rtonumber\2*>\4,\6.D\0\0\4\0\4\0\a'\0\0\0006\1\1\0009\1\2\1'\3\3\0B\1\2\2&\0\1\0L\0\2\0\r%Y/%m/%d\tdate\aos\20periodic/daily/I\0\0\6\0\6\0\f'\0\0\0006\1\1\0009\1\2\1'\3\3\0B\1\2\2'\2\4\0006\3\1\0009\3\2\3'\5\5\0B\3\2\2&\0\3\0L\0\2\0\a%Y\6-\a%V\tdate\aos\6W@\0\0\5\0\4\1\b6\0\0\0009\0\1\0'\2\2\0006\3\0\0009\3\3\3B\3\1\2\22\3\0\3D\0\3\0\ttime\r%Y-%m-%d\tdate\aos€Æ\n@\0\0\5\0\4\1\b6\0\0\0009\0\1\0'\2\2\0006\3\0\0009\3\3\3B\3\1\2\23\3\0\3D\0\3\0\ttime\r%Y-%m-%d\tdate\aos€Æ\n\1\0\1\6\0\n\0\23\n\0\0\0X\1\2€\a\0\0\0X\1\6€6\1\1\0006\3\2\0009\3\3\3'\5\4\0B\3\2\0C\1\0\0\18\3\0\0009\1\5\0'\4\6\0'\5\a\0B\1\4\2\18\3\1\0009\1\5\1'\4\b\0'\5\0\0B\1\4\2\18\3\1\0009\1\t\1D\1\2\0\nlower\18[^A-Za-z0-9-]\6-\6 \tgsub\15%Y%m%d%H%M\tdate\aos\rtostring\5K\0\1\6\0\5\0\t9\1\0\0006\2\1\0009\4\2\0B\2\2\2#\1\2\1\18\4\1\0009\2\3\1'\5\4\0D\2\3\0\b.md\16with_suffix\aid\rtostring\bdir@\0\1\4\0\4\0\a6\1\0\0009\1\1\0019\1\2\0015\3\3\0>\0\2\3B\1\2\1K\0\1\0\1\2\0\0\rxdg-open\rjobstart\afn\bvimœ\6\1\0\6\0(\0-6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0004\3\3\0005\4\3\0>\4\1\3=\3\5\0025\3\6\0=\3\a\0025\3\b\0005\4\n\0003\5\t\0=\5\v\0043\5\f\0=\5\r\0043\5\14\0=\5\15\0043\5\16\0=\5\17\0043\5\18\0=\5\19\4=\4\20\3=\3\21\0023\3\22\0=\3\23\0023\3\24\0=\3\25\0025\3\26\0=\3\27\0025\3\28\0005\4\30\0005\5\29\0=\5\31\0045\5 \0=\5!\4=\4\"\3=\3#\0025\3$\0=\3%\0023\3&\0=\3'\2B\0\2\1K\0\1\0\20follow_url_func\0\16attachments\1\0\1\15img_folder\24_ignore/Attachments\aui\15checkboxes\6x\1\0\2\rhl_group\17ObsidianDone\tchar\5\6 \1\0\0\1\0\2\rhl_group\17ObsidianTodo\tchar\tó°„±\1\0\1\venable\2\15completion\1\0\2\14min_chars\3\2\rnvim_cmp\2\19note_path_func\0\17note_id_func\0\14templates\18substitutions\14yesterday\0\rtomorrow\0\16weekly_note\0\14daily_tag\0\14date_long\1\0\0\0\1\0\3\16time_format\n%H:%M\16date_format\r%Y-%m-%d\vfolder\22_ignore/Templates\16daily_notes\1\0\4\17alias_format\14%B %d, %Y\rtemplate\18Daily-nvim.md\16date_format\r%Y-%m-%d\vfolder\5\15workspaces\1\0\3\23new_notes_location\17notes_subdir\17notes_subdir\5\24disable_frontmatter\2\1\0\2\tname\rpersonal\tpath\20~/obsidian-2025\nsetup\robsidian\frequire\0", "config", "obsidian.nvim")
time([[Config for obsidian.nvim]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
