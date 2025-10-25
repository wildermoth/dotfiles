local utils = require('obsidian-helpers.linter.utils')
local tags = require('obsidian-helpers.linter.tags')
local fm_update = require('obsidian-helpers.linter.frontmatter-update')

local M = {}

function M.update_obsidian_frontmatter()
    local bufname = vim.api.nvim_buf_get_name(0)
    if not bufname:match("obsidian%-2025") or not bufname:match("%.md$") then
        return
    end

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local fm_start, fm_end = utils.find_frontmatter_boundaries(lines)

    if not fm_start or not fm_end then
        return
    end

    local first_h1 = utils.find_first_h1(lines, fm_end)
    if not first_h1 then
        return
    end

    local updated = false

    local existing_tags = tags.extract_existing_tags(lines, fm_start, fm_end)
    local new_tags = tags.extract_hashtags_from_content(lines, fm_end)
    local hashtags_removed = tags.remove_hashtags_from_content(lines, fm_end)

    local merged_tags = tags.merge_tags(existing_tags, new_tags)
    local tags_array = tags.tags_to_sorted_array(merged_tags)

    local title_updated = fm_update.update_title(lines, first_h1, fm_start, fm_end)

    local aliases_updated
    fm_end, aliases_updated = fm_update.update_aliases(lines, first_h1, fm_start, fm_end)

    local tags_line_updated
    fm_end, tags_line_updated = fm_update.ensure_tags_line_exists(lines, fm_start, fm_end)

    fm_end = tags.remove_existing_tag_lines(lines, fm_start, fm_end)

    local tags_inserted
    fm_end, tags_inserted = tags.insert_tags_into_frontmatter(lines, tags_array, fm_start, fm_end)

    updated = hashtags_removed or title_updated or aliases_updated or tags_line_updated or tags_inserted

    if updated then
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    end
end

return M
