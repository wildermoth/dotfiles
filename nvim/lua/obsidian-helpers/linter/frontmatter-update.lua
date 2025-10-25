local M = {}

function M.update_title(lines, first_h1, fm_start, fm_end)
    local updated = false

    for i = fm_start + 1, fm_end - 1 do
        if lines[i]:match("^title:") then
            local new_line = "title: " .. first_h1
            if lines[i] ~= new_line then
                lines[i] = new_line
                updated = true
            end
            break
        end
    end

    return updated
end

function M.update_aliases(lines, first_h1, fm_start, fm_end)
    local updated = false
    local lines_to_remove = {}

    for i = fm_start + 1, fm_end - 1 do
        if lines[i]:match("^aliases:") then
            local new_line = "aliases: " .. first_h1
            if lines[i] ~= new_line then
                lines[i] = new_line
                updated = true
            end

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
        updated = true
        fm_end = fm_end - 1
    end

    return fm_end, updated
end

function M.ensure_tags_line_exists(lines, fm_start, fm_end)
    local updated = false

    for i = fm_start + 1, fm_end - 1 do
        if lines[i]:match("^tags:") then
            if lines[i] ~= "tags:" then
                lines[i] = "tags:"
                updated = true
            end
            return fm_end, updated
        end
    end

    return fm_end, updated
end

return M
