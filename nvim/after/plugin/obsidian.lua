-- Auto-add frontmatter to new notes created via ObsidianSearch or daily notes
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*/obsidian-2025/*.md",
    callback = function()
        -- Small delay to let obsidian.nvim finish creating the file
        vim.defer_fn(function()
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

            -- Check if file has no frontmatter
            local has_frontmatter = false
            if #lines > 0 and lines[1] == "---" then
                has_frontmatter = true
            end

            -- If no frontmatter, add it
            if not has_frontmatter then
                -- Extract title from H1 or filename
                local title = ""
                for _, line in ipairs(lines) do
                    local h1 = line:match("^#%s+(.+)")
                    if h1 then
                        title = h1
                        break
                    end
                end

                -- If no H1 found, use filename
                if title == "" then
                    local filename = vim.fn.expand("%:t:r")
                    -- Check if it's a date format (YYYY-MM-DD)
                    if filename:match("^%d%d%d%d%-%d%d%-%d%d$") then
                        -- It's a daily note, format title as "Month DD, YYYY"
                        local year, month, day = filename:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
                        title = os.date("%B %d, %Y", os.time({year=year, month=month, day=day}))
                    else
                        title = filename
                    end
                end

                local date_created = os.date("%Y-%m-%d")

                local content = string.format([[---
title: %s
tags:
aliases: %s
date created: %s
up:
---

# %s
]], title, title, date_created, title)

                local new_lines = vim.split(content, "\n")
                if new_lines[#new_lines] == "" then
                    table.remove(new_lines)
                end

                vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
                vim.api.nvim_win_set_cursor(0, {9, #new_lines[9]})

                -- Auto-save the file
                vim.cmd('write')
            end
        end, 50)
    end,
})

-- Override ObsidianNew command to use timestamp ID
vim.api.nvim_create_user_command('ObsidianNew', function(opts)
    local title = opts.args
    if not title or title == "" then
        vim.ui.input({ prompt = 'Note title: ' }, function(input_title)
            if input_title and input_title ~= "" then
                title = input_title
            else
                return
            end
        end)
        if not title then return end
    end

    local client = require('obsidian').get_client()
    local note_id = tostring(os.date("%Y%m%d%H%M%S"))
    local date_created = os.date("%Y-%m-%d")

    local content = string.format([[---
title: %s
tags:
aliases: %s
date created: %s
up:
---

# %s
]], title, title, date_created, title)

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
end, { nargs = '?', desc = 'Create new note with timestamp ID', force = true })

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
        local note_id = tostring(os.date("%Y%m%d%H%M%S"))
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
            vim.api.nvim_win_set_cursor(0, { 9, #lines[9] })
        end, 100)
    end)
end, { desc = 'New Zettelkasten note' })

vim.keymap.set('n', '<leader>ob', ':ObsidianBacklinks<CR>', { desc = 'Show backlinks' })

-- Quick new note from search (uses same logic as <leader>on)
vim.keymap.set('n', '<leader>oh', function()
    vim.ui.input({ prompt = 'Note title: ' }, function(input_title)
        if not input_title or input_title == '' then
            return
        end

        local client = require('obsidian').get_client()
        local note_id = tostring(os.date("%Y%m%d%H%M%S"))
        local date_created = os.date("%Y-%m-%d")

        local content = string.format([[---
title: %s
tags:
aliases: %s
date created: %s
up:
---

# %s
]], input_title, input_title, date_created, input_title)

        local note = client:create_note({
            id = note_id,
            title = input_title,
            dir = client.dir,
        })

        client:open_note(note)

        vim.defer_fn(function()
            local lines = vim.split(content, "\n")
            if lines[#lines] == "" then
                table.remove(lines)
            end
            vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
            vim.api.nvim_win_set_cursor(0, { 9, #lines[9] })
        end, 100)
    end)
end, { desc = 'Quick new note (timestamp ID)' })
vim.keymap.set('n', 'gf', function()
    if require('obsidian').util.cursor_on_markdown_link() then
        return '<cmd>ObsidianFollowLink<CR>'
    else
        return 'gf'
    end
end, { noremap = false, expr = true, desc = 'Follow link or use default gf' })
