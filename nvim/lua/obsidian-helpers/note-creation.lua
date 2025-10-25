local frontmatter = require('obsidian-helpers.frontmatter')

local M = {}

function M.create_note_with_frontmatter(title)
    local client = require('obsidian').get_client()
    local note_id = tostring(os.date("%Y%m%d%H%M%S"))
    local content = frontmatter.generate_template(title)

    local note = client:create_note({
        id = note_id,
        title = title,
        dir = client.dir,
    })

    client:open_note(note)

    vim.defer_fn(function()
        local lines = vim.split(content, "\n")
        if lines[#lines] == "" then
            table.remove(lines)
        end
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        vim.api.nvim_win_set_cursor(0, {9, #lines[9]})
    end, 100)
end

return M
