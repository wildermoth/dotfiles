-- Obsidian linter for Neovim
-- Automatically updates YAML frontmatter on save to match Obsidian conventions:
-- - Sets title/aliases to match first H1 heading
-- - Extracts hashtags from content and moves them to tags array
-- - Removes hashtags from content after extraction

local linter = require('obsidian-helpers.linter')

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*/obsidian-2025/*.md",
    callback = linter.update_obsidian_frontmatter,
    desc = "Update Obsidian YAML frontmatter title and aliases from first H1",
})
