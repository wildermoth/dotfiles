local M = {}

function M.extract_existing_tags(lines, fm_start, fm_end)
    local existing_tags = {}

    for i = fm_start + 1, fm_end - 1 do
        local line = lines[i]
        if line:match("^tags:") then
            local tags_content = line:match("^tags:%s*%[(.-)%]")
            if tags_content then
                for tag in tags_content:gmatch("([%w%-_/]+)") do
                    existing_tags[tag] = true
                end
            else
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

    return existing_tags
end

function M.extract_hashtags_from_content(lines, fm_end)
    local new_tags = {}

    for i = fm_end + 1, #lines do
        for tag in lines[i]:gmatch("#([%w%-_/]+)") do
            if not new_tags[tag] then
                new_tags[tag] = true
            end
        end
    end

    return new_tags
end

function M.remove_hashtags_from_content(lines, fm_end)
    local updated = false

    for i = fm_end + 1, #lines do
        local line = lines[i]
        local original_line = line

        line = line:gsub("#[%w%-_/]+%s*", "")
        line = line:gsub("%s+", " ")
        line = line:gsub("^%s+", ""):gsub("%s+$", "")

        if line ~= original_line then
            lines[i] = line
            updated = true
        end
    end

    return updated
end

function M.merge_tags(existing, new)
    local merged = {}
    for tag, _ in pairs(existing) do
        merged[tag] = true
    end
    for tag, _ in pairs(new) do
        merged[tag] = true
    end
    return merged
end

function M.tags_to_sorted_array(tags)
    local array = {}
    for tag, _ in pairs(tags) do
        table.insert(array, tag)
    end
    table.sort(array)
    return array
end

function M.remove_existing_tag_lines(lines, fm_start, fm_end)
    local lines_to_remove = {}

    for i = fm_start + 1, fm_end - 1 do
        if lines[i]:match("^tags:") then
            local j = i + 1
            while j <= fm_end - 1 and lines[j]:match("^%s*-%s") do
                table.insert(lines_to_remove, j)
                j = j + 1
            end
            break
        end
    end

    for i = #lines_to_remove, 1, -1 do
        table.remove(lines, lines_to_remove[i])
        fm_end = fm_end - 1
    end

    return fm_end
end

function M.insert_tags_into_frontmatter(lines, tags_array, fm_start, fm_end)
    if #tags_array == 0 then
        return fm_end, false
    end

    local updated = false
    for i = fm_start + 1, fm_end - 1 do
        if lines[i]:match("^tags:$") then
            for idx = #tags_array, 1, -1 do
                table.insert(lines, i + 1, "  - " .. tags_array[idx])
                fm_end = fm_end + 1
                updated = true
            end
            break
        end
    end

    return fm_end, updated
end

return M
