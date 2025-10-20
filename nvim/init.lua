-- Load settings and keymaps first
require("config.settings")
require("config.keymaps")

-- Bootstrap and setup lazy.nvim
require("config.lazy")

-- Oil setup (required after plugins load)
require("oil").setup()
