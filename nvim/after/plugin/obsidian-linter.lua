-- Obsidian Linter behavior: Update YAML frontmatter on save
-- Replicates yaml-title and yaml-title-alias rules

local function update_obsidian_frontmatter()
    -- Only run in markdown files in obsidian vault
    local bufname = vim.api.nvim_buf_get_name(0)
    if not bufname:match("obsidian%-2025") or not bufname:match("%.md$") then
        return
    end

    -- Get all lines
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    -- Find frontmatter boundaries
    local fm_start = nil
    local fm_end = nil
    for i, line in ipairs(lines) do
        if line == "---" then
            if fm_start == nil then
                fm_start = i
            else
                fm_end = i
                break
            end
        end
    end

    if not fm_start or not fm_end then
        return -- No frontmatter
    end

    -- Find first H1 heading
    local first_h1 = nil
    for i = fm_end + 1, #lines do
        local heading = lines[i]:match("^#%s+(.+)")
        if heading then
            first_h1 = heading
            break
        end
    end

    if not first_h1 then
        return -- No H1 found
    end

    -- First, extract existing tags from frontmatter to preserve them
    local existing_tags = {}
    for i = fm_start + 1, fm_end - 1 do
        local line = lines[i]
        if line:match("^tags:") then
            -- Check for single-line array format: tags: [tag1, tag2]
            local tags_content = line:match("^tags:%s*%[(.-)%]")
            if tags_content then
                for tag in tags_content:gmatch("([%w%-_/]+)") do
                    existing_tags[tag] = true
                end
            else
                -- Check for multi-line bullet list format
                local j = i + 1
                while j <= fm_end - 1 and lines[j]:match("^%s*-%s") do
                    local tag = lines[j]:match("^%s*-%s*(.+)$")
                    if tag then
                        existing_tags[tag] = true
                    end
                    j = j + 1
                end
            end
            break
        end
    end

    -- Track if any changes are made
    local updated = false
    local lines_to_remove = {}

    -- Extract hashtags from content (outside frontmatter) and remove them
    local new_tags = {}
    for i = fm_end + 1, #lines do
        local line = lines[i]
        local original_line = line

        -- Find all hashtags in the line
        for tag in line:gmatch("#([%w%-_/]+)") do
            if not new_tags[tag] then
                new_tags[tag] = true
            end
        end

        -- Remove hashtags from the line
        -- Replace #tag with nothing, handling spaces around it
        line = line:gsub("#[%w%-_/]+%s*", "")
        -- Clean up multiple spaces left behind
        line = line:gsub("%s+", " ")
        -- Trim trailing/leading spaces
        line = line:gsub("^%s+", ""):gsub("%s+$", "")

        if line ~= original_line then
            lines[i] = line
            updated = true
        end
    end

    -- Merge existing tags with new tags
    local tags = {}
    for tag, _ in pairs(existing_tags) do
        tags[tag] = true
    end
    for tag, _ in pairs(new_tags) do
        tags[tag] = true
    end

    -- Convert tags table to sorted array
    local tags_array = {}
    for tag, _ in pairs(tags) do
        table.insert(tags_array, tag)
    end
    table.sort(tags_array)

    -- Update title and aliases in frontmatter

    for i = fm_start + 1, fm_end - 1 do
        local line = lines[i]

        -- Update title
        if line:match("^title:") then
            local current_title = line:match("^title:%s*(.*)$") or ""
            -- Always update to match first H1
            local new_line = "title: " .. first_h1
            if lines[i] ~= new_line then
                lines[i] = new_line
                updated = true
            end
        end

        -- Update aliases - always replace with just the first H1
        if line:match("^aliases:") then
            -- Always set aliases to just the first H1, regardless of current format
            local new_line = "aliases: " .. first_h1
            if lines[i] ~= new_line then
                lines[i] = new_line
                updated = true
            end

            -- Check if there are multi-line array items following (indented with -)
            -- Mark them for removal
            local j = i + 1
            while j <= fm_end - 1 and lines[j]:match("^%s*-%s") do
                table.insert(lines_to_remove, j)
                j = j + 1
            end
        end

        -- Update tags from extracted hashtags
        if line:match("^tags:") then
            -- Only update if we have tags to add
            if #tags_array > 0 then
                -- Keep the tags: line
                if lines[i] ~= "tags:" then
                    lines[i] = "tags:"
                    updated = true
                end

                -- Remove existing multi-line tag array items
                local j = i + 1
                while j <= fm_end - 1 and lines[j]:match("^%s*-%s") do
                    table.insert(lines_to_remove, j)
                    j = j + 1
                end

                -- Insert new tags as multi-line bullet list after tags: line
                for idx = #tags_array, 1, -1 do
                    table.insert(lines, i + 1, "  - " .. tags_array[idx])
                    fm_end = fm_end + 1
                    updated = true
                end
            end
        end
    end

    -- Remove multi-line array entries (in reverse order to maintain indices)
    for i = #lines_to_remove, 1, -1 do
        table.remove(lines, lines_to_remove[i])
        updated = true
        fm_end = fm_end - 1  -- Adjust frontmatter end
    end

    -- Update buffer if changes were made
    if updated then
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    end
end

-- Run on BufWritePre for markdown files (before save)
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*/obsidian-2025/*.md",
    callback = update_obsidian_frontmatter,
    desc = "Update Obsidian YAML frontmatter title and aliases from first H1",
})
