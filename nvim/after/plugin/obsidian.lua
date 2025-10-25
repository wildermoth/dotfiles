-- Obsidian keybindings
vim.keymap.set('n', '<leader>os', ':ObsidianSearch<CR>', { desc = 'Search notes' })
vim.keymap.set('n', '<leader>od', ':ObsidianToday<CR>', { desc = "Today's daily note" })
vim.keymap.set('n', '<leader>ot', ':ObsidianTomorrow<CR>', { desc = "Tomorrow's note" })
vim.keymap.set('n', '<leader>oy', ':ObsidianYesterday<CR>', { desc = "Yesterday's note" })

-- Create new Zettelkasten note with timestamp ID
vim.keymap.set('n', '<leader>on', function()
    -- Prompt for title
    vim.ui.input({ prompt = 'Note title: ' }, function(input_title)
        if not input_title or input_title == '' then
            return -- User cancelled
        end

        local client = require('obsidian').get_client()
        local note_id = tostring(os.date("%Y%m%d%H%M"))

        -- Build the template content manually with substitutions
        local day = tonumber(os.date("%d"))
        local suffix = "th"
        if day == 1 or day == 21 or day == 31 then
            suffix = "st"
        elseif day == 2 or day == 22 then
            suffix = "nd"
        elseif day == 3 or day == 23 then
            suffix = "rd"
        end
        local date_created = os.date("%Y-%m-%d")

        -- Create the note content
        local content = string.format([[---
title: %s
tags:
aliases: %s
date created: %s
up:
---

# %s
]], input_title, input_title, date_created, input_title)

        -- Create note with empty content first
        local note = client:create_note({
            id = note_id,
            title = input_title,
            dir = client.dir,
        })

        -- Open the note
        client:open_note(note)

        -- Wait for buffer to load, then replace content
        vim.defer_fn(function()
            local lines = vim.split(content, "\n")
            -- Remove last empty line if present
            if lines[#lines] == "" then
                table.remove(lines)
            end
            vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
            -- Position cursor at end of title
            vim.api.nvim_win_set_cursor(0, {9, #lines[9]})
        end, 100)
    end)
end, { desc = 'New Zettelkasten note' })

vim.keymap.set('n', '<leader>ob', ':ObsidianBacklinks<CR>', { desc = 'Show backlinks' })
vim.keymap.set('n', 'gf', function()
    if require('obsidian').util.cursor_on_markdown_link() then
        return '<cmd>ObsidianFollowLink<CR>'
    else
        return 'gf'
    end
end, { noremap = false, expr = true, desc = 'Follow link or use default gf' })
