local M = {}

function M.generate_template(title)
    local date_created = os.date("%Y-%m-%d")
    return string.format([[---
title: %s
tags:
aliases: %s
date created: %s
up:
---

# %s
]], title, title, date_created, title)
end

function M.extract_title_from_buffer()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    for _, line in ipairs(lines) do
        local h1 = line:match("^#%s+(.+)")
        if h1 then
            return h1
        end
    end

    local filename = vim.fn.expand("%:t:r")
    if M.is_daily_note(filename) then
        return M.format_daily_title(filename)
    end

    return filename
end

function M.is_daily_note(filename)
    return filename:match("^%d%d%d%d%-%d%d%-%d%d$") ~= nil
end

function M.format_daily_title(filename)
    local year, month, day = filename:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
    return os.date("%B %d, %Y", os.time({year=year, month=month, day=day}))
end

function M.has_frontmatter()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    return #lines > 0 and lines[1] == "---"
end

function M.extract_tags_from_body()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local tags = {}
    local frontmatter_end = 0
    local in_frontmatter = false

    -- Find where frontmatter ends
    for i, line in ipairs(lines) do
        if i == 1 and line == "---" then
            in_frontmatter = true
        elseif in_frontmatter and line == "---" then
            frontmatter_end = i
            break
        end
    end

    -- Extract tags from body (after frontmatter)
    for i = frontmatter_end + 1, #lines do
        for tag in lines[i]:gmatch("#([%w%-_]+)") do
            if not vim.tbl_contains(tags, tag) then
                table.insert(tags, tag)
            end
        end
    end

    return tags
end

function M.remove_tags_from_body()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local frontmatter_end = 0
    local in_frontmatter = false

    -- Find where frontmatter ends
    for i, line in ipairs(lines) do
        if i == 1 and line == "---" then
            in_frontmatter = true
        elseif in_frontmatter and line == "---" then
            frontmatter_end = i
            break
        end
    end

    -- Remove tags from body lines (including the tag word)
    for i = frontmatter_end + 1, #lines do
        -- Remove hashtags and clean up extra spaces
        lines[i] = lines[i]:gsub("#[%w%-_]+", "")
        -- Clean up multiple consecutive spaces
        lines[i] = lines[i]:gsub("%s+", " ")
        -- Trim leading/trailing spaces
        lines[i] = lines[i]:gsub("^%s+", ""):gsub("%s+$", "")
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

function M.add_tags_to_frontmatter(new_tags)
    if #new_tags == 0 then return end

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local frontmatter_end = 0
    local tags_line = nil

    -- Find frontmatter section and tags line
    for i, line in ipairs(lines) do
        if i == 1 and line ~= "---" then
            return -- No frontmatter
        end
        if i > 1 and line == "---" then
            frontmatter_end = i
            break
        end
        if line:match("^tags:%s*") or line:match("^tags:$") then
            tags_line = i
        end
    end

    if not tags_line then return end

    -- Get existing tags (handle both comma-separated and YAML list format)
    local existing_tags = {}
    local tags_content = lines[tags_line]:match("^tags:%s*(.*)")

    -- Check if using YAML list format (next lines start with '  - ')
    local uses_yaml_list = false
    if tags_line < #lines and lines[tags_line + 1]:match("^%s+%-%s+") then
        uses_yaml_list = true
        -- Collect existing YAML list tags
        for i = tags_line + 1, frontmatter_end - 1 do
            local list_tag = lines[i]:match("^%s+%-%s+(.+)")
            if list_tag then
                table.insert(existing_tags, list_tag)
            else
                break
            end
        end
    elseif tags_content and tags_content ~= "" then
        -- Parse comma-separated format
        for tag in tags_content:gmatch("[^,]+") do
            tag = tag:gsub("^%s*", ""):gsub("%s*$", "")
            table.insert(existing_tags, tag)
        end
    end

    -- Merge new tags
    for _, tag in ipairs(new_tags) do
        if not vim.tbl_contains(existing_tags, tag) then
            table.insert(existing_tags, tag)
        end
    end

    -- Update tags - use comma-separated format for simplicity
    if #existing_tags > 0 then
        lines[tags_line] = "tags: " .. table.concat(existing_tags, ", ")

        -- Remove old YAML list format if it existed
        if uses_yaml_list then
            local lines_to_remove = 0
            for i = tags_line + 1, frontmatter_end - 1 do
                if lines[i]:match("^%s+%-%s+") then
                    lines_to_remove = lines_to_remove + 1
                else
                    break
                end
            end
            if lines_to_remove > 0 then
                for i = 1, lines_to_remove do
                    table.remove(lines, tags_line + 1)
                end
            end
        end
    else
        lines[tags_line] = "tags:"
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

return M
