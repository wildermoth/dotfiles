return {
    "epwalsh/obsidian.nvim",
    version = "*",  -- Use latest release
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("obsidian").setup({
            workspaces = {
                {
                    name = "personal",
                    path = "/mnt/c/Users/James/Documents/GitHub/obsidian",
                }
            },
            -- Disable default mappings to avoid conflicts
            mappings = {},
        })
    end,
}
