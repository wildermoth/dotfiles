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

return M
