local M = {}

function M.find_frontmatter_boundaries(lines)
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

    return fm_start, fm_end
end

function M.find_first_h1(lines, fm_end)
    for i = fm_end + 1, #lines do
        local heading = lines[i]:match("^#%s+(.+)")
        if heading then
            return heading
        end
    end
    return nil
end

return M
